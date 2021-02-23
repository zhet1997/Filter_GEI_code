%2019-3-15
%3.15保护消费者权益
%此类代表一个完整的CoKriging模型迭代优化过程，在整个过程结束之前不重新构造
%此类还用来传递一些需要在多次迭代中传递的信息
classdef Iteration<handle
    properties
        Sample
        Model
       % option
    end
    
    properties
        border
        y_min_co
        y_min%样本点中最小值
        y_min_low%低精度样本点最小值
        y_min_res%响应面的最小值
        EI_max
        g
        cost=0.1; %高低精度消耗算力比例
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
        
        %corr1_record
        %corr2_record
        %corr3_record
    end
    
    properties%result
        best_value
        best_location
        error_value
        error_location
        
    end
    
    properties(Access = private)%local
         Model_local
        border_local
        y_min_co_local
        y_min_local%样本点中最小值
        y_min_res_local%响应面的最小值
        EI_max_local
        
    end
    
    methods
        function obj = Iteration(sample,model)
            
            if isa(sample,'Sample')==0
                error("输入的不是合法的Sample类对象，请仔细检查。");
            end
            if isa(model,'CoKriging')==0&&isa(model,'Kriging')==0&&isa(model,'HierarchicalKriging')==0
                error("输入的不是合法的CoKriging类对象，请仔细检查。");
            end
            
            obj.Sample = sample;
            obj.Model = model;
            
            %确定边界
            g_down=zeros(obj.Sample.dimension,1);
            g_up=ones(obj.Sample.dimension,1);
            obj.border=[g_down,g_up];
            
            obj.get_y_min;
            %===========================
            obj.add_record = [obj.Sample.initial_num_l,obj.Sample.initial_num_h];
        end
        %================================================================================
        %迭代函数（加入新的样本点并更新模型状态）
        function Update(obj,x_1,x_2)%有两种点时，前一个为低精度
            if nargin==2%注意在计算输入参数数目时，对象也计入在内
                obj.Sample.update(x_1);
            elseif nargin==3
                obj.Sample.update(x_1,x_2);
                 obj.add_record = [obj.add_record;size(x_1,1),size(x_2,1)];
            end
            obj.Model = krigingfamily( obj.Sample.points, obj.Sample.values,class(obj.Model));
            %obj.Model = oodacefit( obj.Sample.points, obj.Sample.values, struct() );
            obj.get_y_min;
            % obj.result;
            %obj.corr(1);%计算全局响应面吻合程度
            
            %
            %             if obj.Sample.start_local==1
            %                %建立局部响应面
            %               obj.Model_local = oodacefit( obj.Sample.points_local, obj.Sample.values_local, struct() );
            %               %确定局部响应面边界
            %               g_down=obj.Sample.center_point' - 0.5*obj.Sample.ratio_line;
            %               g_up = obj.Sample.center_point' + 0.5*obj.Sample.ratio_line;
            %               obj.border_local=[g_down,g_up];
            %               obj.get_y_min_local;
            %               %计算局部响应面吻合程度
            %               obj.corr(2);
            %               obj.corr(3)
            %             end
           
        end
        
        
        %==================================================================================================
        %参数计算
        function get_y_min(obj)
            
%             [obj.y_min_co,obj.y_min_res] = ga(@obj.res_surf,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
%             obj.y_min  = min(obj.Sample.values_h);
%             obj.y_min_low = min(obj.Sample.values_l);
        end
        
        function get_y_min_local(obj)
            
            [obj.y_min_co_local,obj.y_min_res_local] = ga(@obj.res_surf_local,obj.Sample.dimension,[],[],[],[],obj.border_local(:,1),obj.border_local(:,2));
            obj.y_min_local  = min(obj.Sample.values_local);
        end
        %===================================================================================
        %响应面建立函数
        
        %低精度
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
        
        
        %高精度
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
        
        %局部
        function y=res_surf_local(obj,x)%
            [y,~]=obj.Model_local.predict(x);
            y = double(y);
        end
        
        function y=mse_surf_local(obj,x)
            [~,s2]=obj.Model_local.predict(x);
            if s2>0
                y=s2;
            else
                y=0 ;
            end
            
            y = double(y);
            
        end
        
        %==================================================================================================
        %选择加点函数
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
            %xx表示点坐标
            %yy表示预测值
            %zz表示EI值
            %ss表示误差值
            
            
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
        
        %EI方法
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
            %xx表示点坐标
            %yy表示预测值
            %zz表示EI值
            %ss表示误差值
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
        
        
        %GEI方法
        function yy=GEI_low(obj,x)%这里ii代表了GEI中g的大小
            gg=obj.g;
            
            
            y=obj.res_surf_l(x);
            mse2=obj.mse_surf_l(x);
            
            s=sqrt(abs(mse2));
            if s<=1e-20
                yy=0;
            else
                u=(obj.y_min-y)/s;
                T(1)=normcdf(u,0,1);%这里的T（1）代表公式中的T0，以下同理
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
        
        function yy=GEI_high(obj,x)%这里gg代表了GEI中g的大小
            gg=obj.g;
            
            y=obj.res_surf(x);
            mse2=obj.mse_surf(x);
            
            
            
            s=sqrt(abs(mse2));
            if s<=1e-20
                yy=0;
            else
                u=(obj.y_min-y)/s;
                T(1)=normcdf(u,0,1);%这里的T（1）代表公式中的T0，以下同理
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
        
        
        
        
        function [xx,yy]=select_GEI(obj,choice)%把选点过程与聚类过程分开
            
            x=zeros(10,obj.Sample.dimension);
            y0=zeros(10,1);
            
            
            switch choice
                case 'low'
                    for i=1:11
                        obj.g=i-1;
                        [x(i,:),y0(i)]=ga(@obj.GEI_low,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
                    end
                    obj.EI_max=-min(y0);%把九个EI中值最大的一个储存起来
                    x(10,:)=obj.y_min_co;%到这里十个坐标都已经储存在矩阵中了
                    
                    
                case 'high'
                    for i=1:11
                        obj.g=i-1;
                        [x(i,:),y0(i)]=ga(@obj.GEI_high,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
                    end
                    obj.EI_max=-min(y0);%把九个EI中值最大的一个储存起来
                    x(10,:)=obj.y_min_co;%到这里十个坐标都已经储存在矩阵中了
                    
            end
            
            xx=x;
            yy=obj.Model.predict(xx);
        end
        
        function xx=cluster(obj,x,dist)%随机保留
            %聚类的目的只有一个，那就是去除距离太近的点
            %但是点的删除标准可以有所不同
            %随机
            %预测值
            %EI
            
            %开始聚类
            y = pdist(x,'euclid');
            z = linkage(y,'single');
            xx=ones(10,obj.Sample.dimension)*(-1);
            xx=[x;xx];
            for i=1:size(x,1)-1
                if z(i,3)>dist%这里dist是聚类的距离标准，可以改变%之前设为0.1太大了，改为0.05
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
            %聚类的目的只有一个，那就是去除距离太近的点
            %但是点的删除标准可以有所不同
            %随机
            %预测值
            %EI
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
                if z(i,3)>dist%这里dist是聚类的距离标准，可以改变%之前设为0.1太大了，改为0.05
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
            %yy=obj.Model.predict(xx);
           end
        end
        
        function xx=cluster3(obj,x,dist)
            %聚类的目的只有一个，那就是去除距离太近的点
            %但是点的删除标准可以有所不同
            %随机
            %预测值
            %EI
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
            %开始聚类
            y = pdist(x,'euclid');
            z = linkage(y,'single');
            xx=ones(20,obj.Sample.dimension)*(-1);
            xx=[x;xx];
            for i=1:size(x,1)-1
                if z(i,3)>dist%这里dist是聚类的距离标准，可以改变%之前设为0.1太大了，改为0.05
                    break
                end
                %                 r=round(rand(1,1));
                %                 xx(size(x,1)+i,:)=xx(z(i,1),:)*r+xx(z(i,2),:)*(1-r);
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
            %yy=obj.Model.predict(xx);
           end
        end
        
        
        %==================================================================================================
        %停止条件函数
        %EI最大值小于一定范围
        function  bool = Stop_EImax(obj)
            if obj.EI_max<1e-4
                disp("根据EI条件停止迭代")
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
                disp("根据sla条件停止迭代")
                obj.jump_out = 'sla';
                bool = 1;
            else
                bool =0;
            end
        end
        
        %当误差小于一定值时停止
        function  bool = Stop_error(obj,num)
            
            load(['E:\ooDACE\data_about_testfunc\',obj.Sample.functype,'.mat']);
            eval(['best_value_anal=',obj.Sample.functype,'.best_value;']);
            
            if obj.y_min-best_value_anal<num
                disp("根据error条件停止迭代")
                obj.jump_out = 'error';
                bool = 1;
            else
                bool= 0;
            end
            
        end
        
        %当折合加点数超过一定数量停止
        function  bool = Stop_source(obj,num)
            if obj.cost_record(end)>num
                disp("根据折合加点数停止迭代")
                obj.jump_out = 'source';
                bool = 1;
            else
                bool= 0;
            end
            
        end
        
        
        %===================================================================================================
        %记录函数
        %自动记录迭代过程中一些有价值的值
        function  record(obj)
            gen=obj.Sample.gen;
            if strcmp(obj.Sample.samtype,'high')||strcmp(obj.Sample.samtype,'mult')||strcmp(obj.Sample.samtype,'nash')
                %i=obj.Sample.number-obj.Sample.initial_num;
                obj.EI_max_record(gen)=obj.EI_max;
                obj.value_min_record(gen)=min(obj.Sample.values_h);
                obj.cost_record(gen) = obj.Sample.number_h+obj.Sample.number_l*obj.cost;
            else
                obj.EI_max_record(gen)=obj.EI_max;
                obj.value_min_record(gen)=min(obj.Sample.values_l);
            end
        end
        
        
        %====================================================================================================
        %结果函数
        %在一次迭代结束之后形成一个关于这次优化的简单结果
        %此函数使用的前提条件为测试函数是库内已知函数。
        function result(obj)
            obj.best_value = min(obj.value_min_record);
            p = find(obj.Sample.values_h== obj.best_value);
            obj.best_location = obj.Sample.points_h(p,:);
            
            try%增加了try函数，对没有记录的函数也能正常运行；
                load(['E:\ooDACE\data_about_testfunc\',obj.Sample.functype,'.mat']);
                eval(['best_value_anal=',obj.Sample.functype,'.best_value;']);
                eval(['best_location_anal=',obj.Sample.functype,'.best_location_nor;']);
                %如果有多个最优点
                if size(best_location_anal,1)>1
                    for i=1:size(best_location_anal,1)
                        a(i) = max(abs(obj.best_location-best_location_anal(i,:)));
                    end
                    l=find(a==min(a));
                    best_location_anal=best_location_anal(l,:);
                end
                
                obj.error_value = abs(best_value_anal-obj.best_value)/abs(best_value_anal);
                obj.error_location = max(abs(obj.best_location-best_location_anal));
                
                %由于顺序原因，两个记录移动到了这里
                gen=obj.Sample.gen;
                obj.error_value_record(gen)=obj.error_value;
                obj.error_location_record(gen)=obj.error_location;
            catch
                
            end
        end
        
        
        %======================================================================================================
        %计算当前响应面与真实响应面的相关系数
        function corr(obj,how)
            %1.计算主响应面在全局的相关系数
            %2.计算局部响应面在局部的相关系数
            %3.计算主响应面在局部的相关系数
            switch how
                case 1
                    boud = obj.border;
                    type = 0;
                    density=0.2;
                case 2
                    boud = obj.border_local;
                    type = 1;
                    density=0.1;
                case 3
                    boud = obj.border_local;
                    type = 0;
                    density=0.1;
            end
            %获取样本点
            density=0.2;
            cut = 0.05;%去边缘系数
            %xx=cell{1,obj.Sample.dimension};
            for i=1:obj.Sample.dimension
                eval(['x',num2str(i),'=',num2str(boud(i,1)+cut),':',num2str(density),':',num2str(boud(i,2)-cut),';']);
                eval(['xx{1,',num2str(i),'}=x',num2str(i),';']);
            end
            gridx = makeEvalGrid(xx);
            gridy1 = zeros(size(gridx,1),1);%原模型序列
            gridy2 = zeros(size(gridx,1),1);%代理模型序列
            for i=1:size(gridx,1)
                
                gridy1(i) = Testmodel( gridx(i,:),obj.Sample.functype );
                if type==0
                    gridy2(i) =obj.Model.predict( gridx(i,:));
                elseif type==1
                    gridy2(i) =obj.Model_local.predict( gridx(i,:));
                end
            end
            % mean=sum(gridy1)/(density^dimension);
            % mse=sqrt(sum((gridy1-mean).^2)/(density^dimension));
            %corr1 = corr(gridy1,gridy2,'type' , 'pearson');
            corr2 = corr(gridy1,gridy2,'type' ,'spearman');
            % corr3 = corr(gridy1,gridy2,'type' , 'Kendall');
            
            %输出结果
            %fprintf("该响应面的Pearson系数是%s\n",corr1);
            %fprintf("该响应面的Spearman系数是%s\n",corr2);
            %fprintf("该响应面的Kendall系数是%s\n",corr3);
            %记录结果
            gen=obj.Sample.gen;
            switch how
                case 1
                    obj.corr1_record(gen) = corr2;
                case 2
                    obj.corr2_record(gen) = corr2;
                case 3
                    obj.corr3_record(gen) = corr2;
            end
        end
        
        
        
        
        %====================================================================================================
        %报告函数
        %在整个优化结束之后形成一个关于这次优化的简单报告
        
        function report(obj)
            
            fprintf("本次的测试函数是%s\n",obj.Sample.functype);
            fprintf("函数的维度是%d维\n",obj.Sample.dimension);
            fprintf("一共进行了%d次迭代\n",obj.Sample.gen);
            fprintf("共取样本点%d个，其中高精度样本点%d个，低精度样本点%d个\n",obj.Sample.number,obj.Sample.number_h,obj.Sample.number_l);
            fprintf("测试最优结果为%f\n",obj.best_value);
            if abs(obj.error_value)<=1e5
                fprintf("结果误差为%f%%\n ", obj.error_value*100 );
            end
            fprintf("测试最优位置为%s\n",num2str(obj.best_location));
            fprintf("位置误差为%f%%\n ", obj.error_location*100 );
            %obj.corr(1);
            %obj.corr(2);
            %obj.corr(3);
        end
        
        
        
        
        
        
        
        
        
    end
end

