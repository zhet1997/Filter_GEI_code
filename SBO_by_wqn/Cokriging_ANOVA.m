%2019-6-22
classdef Cokriging_ANOVA<handle
    %ANOVA 是用来进行总变差分析的程序
    %ANOVA建立在Kriging响应面的基础上
    
    properties
        Model%直接使用已完成的响应面
        Sample
    end
    
    properties(Dependent)%从Kriging类中提取的原始数据
        R%相关系数矩阵%在Cokriging中这是乘以了系数的。
        beta%回归值
        theta%计算相关系数的超参数
        
        ys%所有样本值
        points%所有样本坐标
        
        dimension%坐标维度
        n%样本个数
        
        F
        
        rho
        sigma_c2
        sigma_d2
        
        
    end
    
    
    properties%计算函数的相关数据
        l%确定变量的维度
        p%不确定变量的维度 %p+l=n
        %x%确定坐标的输入%以l*2的格式输入%左列为参数序号，右列为具体值
       % miu
        
        
        
    end
    
    methods
        function obj =  Cokriging_ANOVA(sample,model)
            if isa(sample,'Sample')==0
                error("输入的不是合法的Sample类对象，请仔细检查。");
            end
            if isa(model,'CoKriging')==0&&isa(model,'Kriging')==0
                error("输入的不是合法的代理模型对象，请仔细检查。");
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
        function [y] = get_A(obj,label_l,x,theta,points)%序号放在label里%都是行向量
            
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
            %B的计算
        
            xx=0:0.001:1;
            inte = zeros(1,1,size(xx,2));
            inte(1,1,:) = xx;
            
            nn = size(points,1);
            b = zeros(nn,obj.p,size(xx,2));
           
            temp = ones(nn,obj.p,size(xx,2)).*inte - ones(nn,obj.p,size(xx,2)).*points(:,label_p);
            temp = temp.*temp;
            temp = temp.*theta(:,label_p);
            b =exp(-temp);
  
            sb = sum(b,3)/size(xx,2);%积分直接用加和表示
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
                error("输入的x参数不规范，请检查");
            end
            label_p = 1:obj.dimension;
            for ii=1:obj.l
                label_p = label_p(label_p~=(label_l(ii)));
            end
          
            %A的计算
            a1 = obj.get_A(label_l,x,obj.theta(1,:),obj.points{1,1});
            a2 = obj.get_A(label_l,x,obj.theta(1,:),obj.points{2,1});
            a3 = obj.get_A(label_l,x,obj.theta(2,:),obj.points{2,1});
            
            A = [a1,zeros(size(a1));a2,a3];
            %B的计算
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

