%2019-6-22
classdef ANOVA_k<handle
    %ANOVA �����������ܱ������ĳ���
    %ANOVA������Kriging��Ӧ��Ļ�����
    
    properties
        Model%ֱ��ʹ������ɵ���Ӧ��
        Sample
    end
    
    properties(Dependent)%��Kriging������ȡ��ԭʼ����
        R%���ϵ������
        beta%�ع�ֵ
        theta%�������ϵ���ĳ�����
        
        ys%��������ֵ
        points%������������
        
        dimension%����ά��
        n%��������
        
        
    end
    
    properties%���㺯�����������
        l%ȷ��������ά��
        p%��ȷ��������ά�� %p+l=n
        %x%ȷ�����������%��l*2�ĸ�ʽ����%����Ϊ������ţ�����Ϊ����ֵ
        miu
        
        
        
    end
    
    methods
        function obj = ANOVA_k(sample,model)
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
        function [y] = get_A(obj,label_l,x)%��ŷ���label��%����������
            
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
            %B�ļ���
            
            xx=0:0.001:1;
            inte = zeros(1,1,size(xx,2));
            inte(1,1,:) = xx;
            
            nn = size(obj.points,1);
            b = zeros(nn,obj.p,size(xx,2));
            
            temp = ones(nn,obj.p,size(xx,2)).*inte - ones(nn,obj.p,size(xx,2)).*obj.points(:,label_p);
            temp = temp.*temp;
            temp = temp.*obj.theta(:,label_p);
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
            
            
            A = obj.get_A(label_l,x);
            label_p = 1:obj.dimension;
            for ii=1:obj.l
                label_p = label_p(label_p~=(label_l(ii)));
            end
            
            %B�ļ���
            
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
        %              %B�ļ���
        %             xx = 0:0.001:1;
        %             b = zeros(obj.n,obj.p,size(xx,2));
        %             for ii=1:size(xx,2)
        %                 temp = ones(obj.n,obj.p)*xx(ii)-obj.points(:,label_p);
        %                 temp = temp.*temp;
        %                 temp = temp.*obj.theta(:,label_p);
        %                 b(:,:,ii) = exp(-temp);
        %             end
        %
        %             sb = sum(b,3)*(1/size(xx,2));%����ֱ���üӺͱ�ʾ
        %             B = prod(sb,2);
        %
        %             %miu = obj.beta + A'*B;
        %
        %
        %             %C�ļ���
        % %              xx = 0:0.001:1;
        % %             c = zeros(obj.n,obj.p,size(xx,2));
        % %             for ii=1:size(xx,2)
        % %                 temp = ones(obj.n,obj.p)*xx(ii)-obj.points(:,label_p);
        % %                 temp = temp.*temp;
        % %                 temp = 2.*temp.*obj.theta(:,label_p);%�����������
        % %                 c(:,:,ii) = exp(-temp);
        % %             end
        %              c = b .* b;%
        %
        %             sc = sum(c,3)*(1/size(xx,2));%����ֱ���üӺͱ�ʾ
        %             C = prod(sc,2);
        %
        %             %D�ļ���
        %             temp = 1:obj.n;
        %             idx = temp(ones(obj.n, 1),:);
        %             m1 = tril( idx, -1 ); % idx  %��ȡ�����Ǿ��󣬲����Խ���
        %             m2 = triu( idx, 1 )'; % idx  %��ȡ�����Ǿ���
        %             m1 = m1(m1~=0); % remove zero's
        %             m2 = m2(m2~=0); % remove zero's
        %
        %
        %             d = b(m1,:,:) .* b(m2,:,:);%
        %             sd = sum(d,3)*(1/size(xx,2));%����ֱ���üӺͱ�ʾ
        %             D = prod(sd,2);
        %
        %             %sigma2�ļ���
        %             y = -(obj.beta-obj.miu)^2 + (A.*A)'*C +2*(A(m1,:,:) .* A(m2,:,:))'*D;
        
        
        
        % end
        
        
        
        
        
    end
end

