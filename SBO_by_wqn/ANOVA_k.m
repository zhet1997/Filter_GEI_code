%2019-6-22
classdef ANOVA_k<handle
    %ANOVA 是用来进行总变差分析的程序
    %ANOVA建立在Kriging响应面的基础上
    
    properties
        Model%直接使用已完成的响应面
        Sample
    end
    
    properties(Dependent)%从Kriging类中提取的原始数据
        R%相关系数矩阵
        beta%回归值
        theta%计算相关系数的超参数
        
        ys%所有样本值
        points%所有样本坐标
        
        dimension%坐标维度
        n%样本个数
        
        
    end
    
    properties%计算函数的相关数据
        l%确定变量的维度
        p%不确定变量的维度 %p+l=n
        %x%确定坐标的输入%以l*2的格式输入%左列为参数序号，右列为具体值
        miu
        
        
        
    end
    
    methods
        function obj = ANOVA_k(sample,model)
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
            beta = obj.Model.alpha;
            
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
        
        
        %==================================================================
        %calcular
        %==================================================================
        function [y] = get_A(obj,label_l,x)%序号放在label里%都是行向量
            
            %ug-xg
            
            if isempty(x)
                y=ones(size(obj.points,1),1);
            else
                temp = ones(size(obj.points,1),obj.l).*x-obj.points(:,label_l);
                temp = temp.*temp;
                temp = temp.*obj.theta(:,label_l);
                temp = exp(-sum(temp,2));
                y = temp;
            end
        end
        
        function [y]= get_B(obj,label_p)
            %B的计算
            
            xx=0:0.001:1;
            inte = zeros(1,1,size(xx,2));
            inte(1,1,:) = xx;
            
            nn = size(obj.points,1);
            b = zeros(nn,obj.p,size(xx,2));
            
            temp = ones(nn,obj.p,size(xx,2)).*inte - ones(nn,obj.p,size(xx,2)).*obj.points(:,label_p);
            temp = temp.*temp;
            temp = temp.*obj.theta(:,label_p);
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
            
            
            A = obj.get_A(label_l,x);
            label_p = 1:obj.dimension;
            for ii=1:obj.l
                label_p = label_p(label_p~=(label_l(ii)));
            end
            
            %B的计算
            
            B = obj.get_B(label_p);
            
            V = obj.R\(obj.ys-ones(obj.n,1)*obj.beta);
            s = A.*B;
            y = obj.beta + V'*sum(s,2);
        end
        
        %         function [y] = get_sigma2(obj,label_l,x)
        %              A = get_A(obj,label_l,x);
        %              label_p = 1:obj.dimension;
        %             for ii=1:obj.l
        %                 label_p = label_p(label_p~=(label_l(ii)));
        %             end
        %
        %              %B的计算
        %             xx = 0:0.001:1;
        %             b = zeros(obj.n,obj.p,size(xx,2));
        %             for ii=1:size(xx,2)
        %                 temp = ones(obj.n,obj.p)*xx(ii)-obj.points(:,label_p);
        %                 temp = temp.*temp;
        %                 temp = temp.*obj.theta(:,label_p);
        %                 b(:,:,ii) = exp(-temp);
        %             end
        %
        %             sb = sum(b,3)*(1/size(xx,2));%积分直接用加和表示
        %             B = prod(sb,2);
        %
        %             %miu = obj.beta + A'*B;
        %
        %
        %             %C的计算
        % %              xx = 0:0.001:1;
        % %             c = zeros(obj.n,obj.p,size(xx,2));
        % %             for ii=1:size(xx,2)
        % %                 temp = ones(obj.n,obj.p)*xx(ii)-obj.points(:,label_p);
        % %                 temp = temp.*temp;
        % %                 temp = 2.*temp.*obj.theta(:,label_p);%区别就在这里
        % %                 c(:,:,ii) = exp(-temp);
        % %             end
        %              c = b .* b;%
        %
        %             sc = sum(c,3)*(1/size(xx,2));%积分直接用加和表示
        %             C = prod(sc,2);
        %
        %             %D的计算
        %             temp = 1:obj.n;
        %             idx = temp(ones(obj.n, 1),:);
        %             m1 = tril( idx, -1 ); % idx  %抽取下三角矩阵，不含对角线
        %             m2 = triu( idx, 1 )'; % idx  %抽取上三角矩阵
        %             m1 = m1(m1~=0); % remove zero's
        %             m2 = m2(m2~=0); % remove zero's
        %
        %
        %             d = b(m1,:,:) .* b(m2,:,:);%
        %             sd = sum(d,3)*(1/size(xx,2));%积分直接用加和表示
        %             D = prod(sd,2);
        %
        %             %sigma2的计算
        %             y = -(obj.beta-obj.miu)^2 + (A.*A)'*C +2*(A(m1,:,:) .* A(m2,:,:))'*D;
        
        
        
        % end
        
        
        
        
        
    end
end

