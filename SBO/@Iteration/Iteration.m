classdef Iteration<handle
    properties
        Sample
        Model
    end
    
    properties
        border
        y_min_co
        y_min
        y_min_low
        y_min_res
        EI_max
        g
        cost=0.1; 
        jump_out
        VF_l=0;
    end
    
    properties %record
        EI_max_record
        error_value_record
        error_location_record
        value_min_record
        cost_record
        add_record
    end
    
    properties%result
        best_value
        best_location
        error_value
        error_location
        
    end
    
    
    methods
        function obj = Iteration(sample,model)
            
            if isa(sample,'Sample')==0
                error("input illeagle Samples object");
            end
            if isa(model,'CoKriging')==0&&isa(model,'Kriging')==0&&isa(model,'HierarchicalKriging')==0
                error("input illeagle Cokriging object");
            end
            
            obj.Sample = sample;
            obj.Model = model;
            
            g_down=zeros(obj.Sample.dimension,1);
            g_up=ones(obj.Sample.dimension,1);
            obj.border=[g_down,g_up];
            
            obj.get_y_min;
            obj.add_record = [obj.Sample.initial_num_l,obj.Sample.initial_num_h];
        end
        %================================================================================

        function Update(obj,x_1,x_2)
            if nargin==2
                obj.Sample.update(x_1);
            elseif nargin==3
                obj.Sample.update(x_1,x_2);
                 obj.add_record = [obj.add_record;size(x_1,1),size(x_2,1)];
            end
            obj.Model = GPfamily( obj.Sample.points, obj.Sample.values,class(obj.Model));

            obj.get_y_min;        
        end
        
        
        %==================================================================================================
        function get_y_min(obj)
            
            [obj.y_min_co,obj.y_min_res] = ga(@obj.res_surf,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
             obj.y_min  = min(obj.Sample.values_h);
        end

        %===================================================================================
        function y=res_surf_l(obj,x)%
            [y,~]=obj.Model.GP{1}.predict(x);
            y = double(y);
        end
        
        function y=mse_surf_l(obj,x)
            [~,s2]=obj.Model.GP{1}.predict(x);
            if s2>0
                y=s2;
            else
                y=0 ;
            end
            
            y = double(y);
            
        end
        
        function y=res_surf(obj,x)%
            [y,~]=obj.Model.predict(x);
            y = double(y);
        end
        
        function y=mse_surf(obj,x)
            [~,s2]=obj.Model.predict(x);
            if s2>0
                y=s2;
            else
                y=0 ;
            end
            
            y = double(y);
            
        end
      
        
        %==================================================================================================
        %adaptive sampling method
        %VF-EI
        function [yy] = VF_EI(obj,x)
            [~,mse2_l] = obj.Model.GP{1}.predict(x);
            [y,mse2_h] = obj.Model.predict(x);

            if mse2_l*obj.Model.alpha^2<=mse2_h
                s2 = mse2_h;
                obj.VF_l = 2;
                
            else
                s2 = mse2_l*obj.Model.alpha^2;
                obj.VF_l = 1;
               
            end
            
            s=sqrt(abs(s2));
            if s<=1e-20
                yy=0;
            else
                yy=(obj.y_min-y)*normcdf((obj.y_min-y)/s,0,1)+...
                    s*normpdf((obj.y_min-y)/s,0,1);
                yy=-yy;
            end
        end
        
        
        function [xx,yy,zz,ss,l]=select_VF_EI(obj)

            [xx,zz] = ga(@obj.VF_EI,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
            obj.EI_max = -zz;
            zz = -zz;
            l = obj.VF_l;
            if obj.VF_l==1
                [yy,ss] = obj.Model.GP{1}.predict(xx);
            else
                [yy,ss] = obj.Model.predict(xx);
            end
      
        end
        
        %EI
        function yy=EI_low(obj,x)
            
            [y,mse2] = obj.Model.GP{1}.predict(x);
            s=sqrt(abs(mse2));
            if s<=1e-20
                yy=0;
            else
                yy=(obj.y_min_low-y)*normcdf((obj.y_min_low-y)/s,0,1)+...
                    s*normpdf((obj.y_min_low-y)/s,0,1);
                yy=-yy;
            end
        end
        
        function yy=EI_high(obj,x)
            [y,mse2] = obj.Model.predict(x);
            s=sqrt(abs(mse2));
            if s<=1e-20
                yy=0;
            else
                yy=(obj.y_min-y)*normcdf((obj.y_min-y)/s,0,1)+...
                    s*normpdf((obj.y_min-y)/s,0,1);
                yy=-yy;
                
            end
        end
        
        function [xx,yy,zz,ss]=select_EI(obj,choice)
            switch choice
                case 'low'
                    [xx,zz] = ga(@obj.EI_low,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
                    obj.EI_max = -zz;
                    zz = -zz;
                    [yy,ss] = obj.Model.GP{1}.predict(xx);
                case 'high'
                    [xx,zz]=ga(@obj.EI_high,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
                    obj.EI_max=-zz;
                    [yy,ss] = obj.Model.predict(xx);
                    zz = -zz;
            end            
            
        end

        %GEI
        function yy=GEI_low(obj,x)
            gg=obj.g;
            
            
            y=obj.res_surf_l(x);
            mse2=obj.mse_surf_l(x);
            
            s=sqrt(abs(mse2));
            if s<=1e-20
                yy=0;
            else
                u=(obj.y_min-y)/s;
                T(1)=normcdf(u,0,1);
                T(2)=-normpdf(u,0,1);
                for i=3:1:gg+1
                    k=i-1;
                    T(i)=-u^(k-1)*normpdf(u,0,1)+(k-1)*T(i-2);
                end
                sum=0;
                if(gg==0)
                    yy=T(1);
                else
                    for i=1:gg+1
                        k=i-1;
                        sum=sum+(-1)^(k)*nchoosek(gg,k)*u^(gg-k)*T(i);
                    end
                    yy=(sum*s^gg)^(1/gg);
                end
                yy=-yy;
            end
        end
        
        function yy=GEI_high(obj,x)
            gg=obj.g;
            
            y=obj.res_surf(x);
            mse2=obj.mse_surf(x);

            s=sqrt(abs(mse2));
            if s<=1e-20
                yy=0;
            else
                u=(obj.y_min-y)/s;
                T(1)=normcdf(u,0,1);
                T(2)=-normpdf(u,0,1);
                for i=3:1:gg+1
                    k=i-1;
                    T(i)=-u^(k-1)*normpdf(u,0,1)+(k-1)*T(i-2);
                end
                sum=0;
                if(gg==0)
                    yy=T(1);
                else
                    for i=1:gg+1
                        k=i-1;
                        sum=sum+(-1)^(k)*nchoosek(gg,k)*u^(gg-k)*T(i);%2019-7-1做出改动，之前都错了
                    end
                    yy=(sum*s^gg)^(1/gg);
                end
                yy=-yy;
            end
        end
        
        [y] = GEI(obj,x,gg);
        [xx,yy]=find_GEI(obj,gmax);

        function [xx,yy]=select_GEI(obj,choice)
            
            x=zeros(10,obj.Sample.dimension);
            y0=zeros(10,1);      
            switch choice
                case 'low'
                    for i=1:11
                        obj.g=i-1;
                        [x(i,:),y0(i)]=ga(@obj.GEI_low,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
                    end
                    obj.EI_max=-min(y0);
                    x(10,:)=obj.y_min_co;
                    
                    
                case 'high'
                    for i=1:11
                        obj.g=i-1;
                        [x(i,:),y0(i)]=ga(@obj.GEI_high,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
                    end
                    obj.EI_max=-min(y0);
                    x(10,:)=obj.y_min_co;
                    
            end
            
            xx=x;
            yy=obj.Model.predict(xx);
        end
        
        function xx=cluster(obj,x,dist)

            y = pdist(x,'euclid');
            z = linkage(y,'single');
            xx=ones(10,obj.Sample.dimension)*(-1);
            xx=[x;xx];
            for i=1:size(x,1)-1
                if z(i,3)>dist
                    break
                end
                r=round(rand(1,1));
                xx(size(x,1)+i,:)=xx(z(i,1),:)*r+xx(z(i,2),:)*(1-r);
                xx(z(i,1),:)=-1;
                xx(z(i,2),:)=-1;
            end
            k=1;
            for i=1:10+size(x,1)
                if xx(i,1)~=-1
                    x0(k,:)=xx(i,:);
                    k=k+1;
                end
            end
            xx=x0;
            %yy=obj.Model.predict(xx);
        end
        
        function xx=cluster2(obj,x,dist)%
            too_close=[];
            for ii = 1:size(x,1)
            temp = obj.Sample.points_h-x(ii,:);
            temp = sum(abs(temp),2);
            indx = find(temp<0.002);
            if isempty(indx)==0
            too_close = [too_close;ii];
            end
            end
           x(too_close,:)=[];
          
           if size(x,1)==0||size(x,1)==1
               xx=x;
           else
            %开始聚类
            y = pdist(x,'euclid');
            z = linkage(y,'single');
            xx=ones(20,obj.Sample.dimension)*(-1);
            xx=[x;xx];
            for i=1:size(x,1)-1
                if z(i,3)>dist
                    break
                end
                %                 r=round(rand(1,1));
                %                 xx(size(x,1)+i,:)=xx(z(i,1),:)*r+xx(z(i,2),:)*(1-r);
                p1 = obj.Sample.points_h - xx(z(i,1),:);
                p2 = obj.Sample.points_h - xx(z(i,2),:);
                
                p1 = min(sum(p1.*p1,2));
                p2 = min(sum(p2.*p2,2));
                
                if p1<p2
                    xx(size(x,1)+i,:)= xx(z(i,2),:);
                else
                    xx(size(x,1)+i,:)= xx(z(i,1),:);
                end  
                xx(z(i,1),:)=-1;
                xx(z(i,2),:)=-1;
            end
            k=1;
            for i=1:10+size(x,1)
                if xx(i,1)~=-1
                    x0(k,:)=xx(i,:);
                    k=k+1;
                end
            end
            xx=x0;
           end
        end
        
        function xx=cluster3(obj,x,dist)

            too_close=[];
            for ii = 1:size(x,1)
            temp = obj.Sample.points_l-x(ii,:);
            temp = sum(abs(temp),2);
            indx = find(temp<0.002);
            if isempty(indx)==0
            too_close = [too_close;ii];
            end
            end
           x(too_close,:)=[];
          
           if size(x,1)==0||size(x,1)==1
               xx=x;
           else
            y = pdist(x,'euclid');
            z = linkage(y,'single');
            xx=ones(20,obj.Sample.dimension)*(-1);
            xx=[x;xx];
            for i=1:size(x,1)-1
                if z(i,3)>dist%
                    break
                end
                p1 = obj.Sample.points_l - xx(z(i,1),:);
                p2 = obj.Sample.points_l - xx(z(i,2),:);
                
                p1 = min(sum(p1.*p1,2));
                p2 = min(sum(p2.*p2,2));
                
                if p1<p2
                    xx(size(x,1)+i,:)= xx(z(i,2),:);
                else
                    xx(size(x,1)+i,:)= xx(z(i,1),:);
                end
                
                
                xx(z(i,1),:)=-1;
                xx(z(i,2),:)=-1;
            end
            k=1;
            for i=1:10+size(x,1)
                if xx(i,1)~=-1
                    x0(k,:)=xx(i,:);
                    k=k+1;
                end
            end
            xx=x0;
           end
        end
        
        
        %==================================================================================================
        %termination conditions
        %EI max
        function  bool = Stop_EImax(obj)
            if obj.EI_max<1e-4
                disp("terminate with EI max")
                obj.jump_out = 'EI';
                bool = 1;
            else
                bool= 0;
            end
            
        end
        
        %sla标准
        function bool=Stop_sla(obj)
            gen=obj.Sample.gen;
            a_begain = obj.Sample.dimension*4;
            a_number = 2*(obj.Sample.dimension);
            if gen<=a_begain
                k=0;
            else
                k=0;
                for i=gen:-1:gen-a_begain+1
                    if obj.value_min_record(i)== obj.value_min_record(i-1)
                        k=k+1;
                    else
                        k=0;
                    end
                end
            end
            
            if k>= a_number
                disp("terminate with sla")
                obj.jump_out = 'sla';
                bool = 1;
            else
                bool =0;
            end
        end
        
        function  bool = Stop_error(obj,num)
            
            load(['.\data_about_testfunc\',obj.Sample.functype,'.mat']);
            eval(['best_value_anal=',obj.Sample.functype,'.best_value;']);
            
            if obj.y_min-best_value_anal<num
                disp("terminate with error min")
                obj.jump_out = 'error';
                bool = 1;
            else
                bool= 0;
            end
            
        end
        function  bool = Stop_source(obj,num)
            if obj.cost_record(end)>num
                disp("terminate with max sampling")
                obj.jump_out = 'source';
                bool = 1;
            else
                bool= 0;
            end
            
        end
        
        
        %===================================================================================================
        %record
        function  record(obj)
            gen=obj.Sample.gen;
            if strcmp(obj.Sample.samtype,'high')||strcmp(obj.Sample.samtype,'mult')
                obj.EI_max_record(gen)=obj.EI_max;
                obj.value_min_record(gen)=min(obj.Sample.values_h);
                obj.cost_record(gen) = obj.Sample.number_h+obj.Sample.number_l*obj.cost;
            else
                obj.EI_max_record(gen)=obj.EI_max;
                obj.value_min_record(gen)=min(obj.Sample.values_l);
            end
        end
        
        
        %====================================================================================================
        %result
        function result(obj)
            obj.best_value = min(obj.value_min_record);
            p = find(obj.Sample.values_h== obj.best_value);
            obj.best_location = obj.Sample.points_h(p,:);
            
            try%增加了try函数，对没有记录的函数也能正常运行；
                load(['.\data_about_testfunc\',obj.Sample.functype,'.mat']);
                eval(['best_value_anal=',obj.Sample.functype,'.best_value;']);
                eval(['best_location_anal=',obj.Sample.functype,'.best_location_nor;']);

                if size(best_location_anal,1)>1
                    for i=1:size(best_location_anal,1)
                        a(i) = max(abs(obj.best_location-best_location_anal(i,:)));
                    end
                    l=find(a==min(a));
                    best_location_anal=best_location_anal(l,:);
                end
                
                obj.error_value = abs(best_value_anal-obj.best_value)/abs(best_value_anal);
                obj.error_location = max(abs(obj.best_location-best_location_anal));
                
                gen=obj.Sample.gen;
                obj.error_value_record(gen)=obj.error_value;
                obj.error_location_record(gen)=obj.error_location;
            catch
                
            end
        end    
    end
end

