%2019-6-22
classdef Cokriging_ANOVA<handle
    %ANOVA �����������ܱ������ĳ���
    %ANOVA������Kriging��Ӧ��Ļ�����
    
    properties
        Model%ֱ��ʹ������ɵ���Ӧ��
        Sample
    end
    
    properties(Dependent)%��Kriging������ȡ��ԭʼ����
        R%���ϵ������%��Cokriging�����ǳ�����ϵ���ġ�
        beta%�ع�ֵ
        theta%�������ϵ���ĳ�����
        
        ys%��������ֵ
        points%������������
        
        dimension%����ά��
        n%��������
        
        F
        
        rho
        sigma_c2
        sigma_d2
        
        
    end
    
    
    properties%���㺯�����������
        l%ȷ��������ά��
        p%��ȷ��������ά�� %p+l=n
        %x%ȷ�����������%��l*2�ĸ�ʽ����%����Ϊ������ţ�����Ϊ����ֵ
       % miu
        
        
        
    end
    
    methods
        function obj =  Cokriging_ANOVA(sample,model)
            if isa(sample,'Sample')==0
                error("����Ĳ��ǺϷ���Sample���������ϸ��顣");
            end
            if isa(model,'CoKriging')==0&&isa(model,'Kriging')==0
                error("����Ĳ��ǺϷ��Ĵ���ģ�Ͷ�������ϸ��顣");
            end
            
            obj.Sample = sample;
            obj.Model = model;
           % obj.miu = obj.get_miu([],[]);
        end
        %==================================================================
        %dependent
        %==================================================================
        function R = get.R(obj)
            R = full(obj.Model.C*obj.Model.C');
        end
        
        function beta = get.beta(obj)
            beta = obj.F*obj.Model.alpha;
            
        end
         function F = get.F(obj)
           a = obj.Model.getRho();
           F = [a{1,1},1];
        end
        
        function theta =get.theta(obj)
            theta = 10.^obj.Model.getHyperparameters;
        end
        
        function ys = get.ys(obj)
            ys = obj.Sample.values;
        end
        
        function points =get.points(obj)
            points = obj.Sample.points;
        end
        
        function dimension =get.dimension(obj)
            dimension = obj.Sample.dimension;
        end
        
        function n= get.n(obj)
            n = obj.Sample.number;
        end
        
         function rho= get.rho(obj)
            rho = obj.Model.getRho();
            rho = rho{1,1};
         end
        
         function sigma_c2= get.sigma_c2(obj)
            sigma_c2 = obj.Model.GP{1}.getProcessVariance();
         end
        
         function sigma_d2= get.sigma_d2(obj)
            sigma_d2 = obj.Model.GP{2}.getProcessVariance();
        end
        
        
        %==================================================================
        %calcular
        %==================================================================
        function [y] = get_A(obj,label_l,x,theta,points)%��ŷ���label��%����������
            
            %ug-xg
           
            if isempty(x)
                y=ones(size(points,1),1);
            else  
            temp = ones(size(points,1),obj.l).*x-points(:,label_l);
            temp = temp.*temp;
            temp = temp.*theta(:,label_l);
            temp = exp(-sum(temp,2));
            y = temp;
            end
         end
        
        function [y]= get_B(obj,label_p,theta,points)
            %B�ļ���
        
            xx=0:0.001:1;
            inte = zeros(1,1,size(xx,2));
            inte(1,1,:) = xx;
            
            nn = size(points,1);
            b = zeros(nn,obj.p,size(xx,2));
           
            temp = ones(nn,obj.p,size(xx,2)).*inte - ones(nn,obj.p,size(xx,2)).*points(:,label_p);
            temp = temp.*temp;
            temp = temp.*theta(:,label_p);
            b =exp(-temp);
  
            sb = sum(b,3)/size(xx,2);%����ֱ���üӺͱ�ʾ
            y = prod(sb,2);
        end
        
        function [y] = get_miu(obj,all)
             if isempty(all)
                label_l = [];
            x = []; 
             else
            label_l = all(1,:);
            x = all(2,:);
             end
            
            
            obj.l = size(x,2);
            obj.p = obj.dimension-obj.l;
             
            if obj.l>=obj.n||obj.l~=size(label_l,2)
                error("�����x�������淶������");
            end
            label_p = 1:obj.dimension;
            for ii=1:obj.l
                label_p = label_p(label_p~=(label_l(ii)));
            end
          
            %A�ļ���
            a1 = obj.get_A(label_l,x,obj.theta(1,:),obj.points{1,1});
            a2 = obj.get_A(label_l,x,obj.theta(1,:),obj.points{2,1});
            a3 = obj.get_A(label_l,x,obj.theta(2,:),obj.points{2,1});
            
            A = [a1,zeros(size(a1));a2,a3];
            %B�ļ���
            b1 = obj.get_B(label_p,obj.theta(1,:),obj.points{1,1});
            b2 = obj.get_B(label_p,obj.theta(1,:),obj.points{2,1});
            b3 = obj.get_B(label_p,obj.theta(2,:),obj.points{2,1});
            
            B = [b1,zeros(size(b1));b2,b3];
            
            C = [obj.rho*obj.sigma_c2*ones(obj.Sample.number_l,1),zeros(obj.Sample.number_l,1)...
                ;obj.rho^2*obj.sigma_c2*ones(obj.Sample.number_h,1),obj.sigma_d2*ones(obj.Sample.number_h,1)];
            
            V = obj.R\(cell2mat(obj.ys)-ones(obj.n,1)*obj.beta);
            s = A.*B.*C;
            y = obj.beta + V'*sum(s,2);
        end
        

            
            
       
            
        
    end
end

