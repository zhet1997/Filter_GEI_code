%2019-3-11
%���������������ڸ������Ժ�����ǰ���£�ͨ������������ѡ��������
%���룺1.���Ժ�����mά����2.���������n��3.ȡ������2*m���󣩣�
%�˺���֮���CoKrigingsho
%1��forrester����
%2��branin����
%3hartmann-3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at��4,4,4,4��
classdef Sample<handle
    properties
        samtype
        functype
        gen=0;
        dimension
    end
    
    properties %low_fidelity
        initial_num_l  %����ӵ���
        number_l
        points_l
        values_l
        
        %A=2 %function_low= function_high*(1/A)+ errorfunction
        errtype
        errpara
    end
    
    properties %high_fidelity
        initial_num_h
        number_h
        points_h
        values_h
        
        way=1;%�߾��ȵ��ȡ������
    end
    
    properties(Dependent)
        number
        points
        values
        
    end
    
    properties(Access = private)%��ֲ�kriging_1��صĲ���
        ratio=0.05;%�ֲ���Ӧ����ƿռ�ռ������ƿռ�ı���
        local_num=3;  %�ֲ���Ӧ����������Ҫ��������
        start_local=0; %�ж��Ƿ����ֲ���Ӧ��
        density
        center_point
    end
    
    properties(Dependent)
        ratio_line %��һ�������ϵ�ռ��
    end
    
    properties(Hidden)
        number_local
        points_local
        values_local
    end
    
    properties(Access = private)%nash
        global_elite
        subset
        
        
    end
    %===============================================================================
    methods
        %===============================================================================
        function obj=Sample(samtype,functype,errtype,errpara,ini1,ini2)%%construct
            
            if strcmp(samtype,'high') && nargin==3
                obj.initial_num_l = [];
                %obj.initial_num_h = ini1;
                obj.initial_num_h = errtype;%���д�ġ�
                obj.number_l = 0;
                %obj.number_h = ini1;
                obj.number_h = errtype;
                
            elseif strcmp(samtype,'low') && nargin==3
                obj.initial_num_l = ini1;
                obj.initial_num_h = [];
                
                obj.number_l = ini1;
                obj.number_h = 0;
                
            elseif strcmp(samtype,'mult') && nargin==6
                obj.initial_num_l = ini1;
                obj.initial_num_h = ini2;
                
                obj.number_l = ini1;
                obj.number_h = ini2;
                
                obj.errpara = errpara;
                obj.errtype =errtype;
                
            elseif strcmp(samtype,'mult') && nargin==4%������������ʱ���
                obj.initial_num_l = errtype;
                obj.initial_num_h = errpara;
                
                obj.number_l = errtype;
                obj.number_h = errpara;
                
                obj.errpara = errpara;
                obj.errtype =errtype;
                %===========================================
            elseif strcmp(samtype,'nash')&& nargin == 3
                obj.initial_num_l = [];
                obj.initial_num_h = ini1.ini;
                
                obj.number_l = 0;
                obj.number_h = ini1.ini;
                
                obj.dimension = size(ini1.subset,2);
                obj.global_elite = ini1.global_elite;
                obj.subset = ini1.subset;
                
            else
                error('Sample�ࣺ����������淶�����飡����������')
                
                
            end
            
            switch functype %ȷ������������ά��
                case 'forrester'
                    obj.dimension = 1;
                case 'branin'
                    obj.dimension = 2;
                case 'hartmann_3D'
                    obj.dimension = 3;
                case 'colville'
                    obj.dimension = 4;
                case 'shekel'
                    obj.dimension = 4;
                case 'goldstein_price'
                    obj.dimension = 2;
                case 'hartmann_4D'
                    obj.dimension = 4;
                case 'hartmann_6D'
                    obj.dimension = 6;
                case 'ackley'
                    obj.dimension = 5;
                case 'E3'%2019-5-14%��������ר��
                    obj.dimension =1;
                case 'XM'%2019-5-14%��������ר��
                    obj.dimension =11;
                case 'E3_7'%2020-6-20%��������
                    obj.dimension =7;
            end
            
            obj.samtype = samtype;
            obj.functype = functype;
       
            if isempty(obj.initial_num_l)==0%����㷨����
                %����;���������
                ad=3;
                obj.points_l=lhsdesign(obj.initial_num_l*ad, obj.dimension);%���Ϊn*m�ľ���
                
                
                for i=1:obj.number_l*(ad-1)
                    y = pdist(obj.points_l,'euclid');
                    z = linkage(y,'single');
                    p1 = z(1,1);%������ӽ���������֮һ
                    p2 = z(1,2);%������ӽ���������֮һ
                    d1 = sum((obj.points_l(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                    d2 = sum((obj.points_l(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                    
                    if d1<d2%ѡ���������Զ����һ��ȥ��
                        p = p2;
                    else
                        p = p1;
                    end
                    
                    obj.points_l(p,:) = [];%ȥ����p����
                    %obj.points_h = [obj.points_h(1:p-1,:);obj.points_h(p+1:end,:)];
                end
                
                
                a=obj.points_l;
                b=1: obj.initial_num_l;
                for k= 1:obj.initial_num_l
                    %                     b(k) = Testmodel(a(k,:),obj.functype);
                    %                     b(k) = b(k) + Errormodel(a(k,:),obj.errtype);
                    %                     b(k) = b(k)/obj.A;
                    %b(k) = Errormodel(a(k,:),obj.errtype);
                    b(k) = Errormodel_dynamic(a(k,:),obj.functype,obj.errtype,obj.errpara);%��̬�;���
                end
                obj.values_l=b';%�����Ϊֱ�������һ��֮��ľ���
                
                
                obj.way = 2;%����е;��ȳ�ʼ�ӵ㣬��ô�߾��ȴӵ;�����ѡ��
            end
            
            %����߾���������
            if isempty(obj.initial_num_h)==0%����㷨����
                switch obj.way
                    case 1%��������
                        
                        obj.points_h = lhsdesign(obj.initial_num_h, obj.dimension);%���Ϊn*m�ľ���
                        a = obj.points_h;
                        b = 1: obj.initial_num_h;
                        for k= 1:obj.initial_num_h
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            if strcmp(obj.samtype,'nash')%2019-7-7�����nash�Ĳ��ֽ�ȥ
                                temp = obj.global_elite;
                                temp(obj.subset) = a(k,:);
                                b(k) = Testmodel_nash(temp,obj.functype);%%�ؼ�λ��
                            else
                                b(k) = Testmodel(a(k,:),obj.functype);%%�ؼ�λ��
                                
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        end
                        obj.values_h = b';%�����Ϊֱ�������һ��֮��ľ���
                        
                        
                    case 2%ֱ�Ӵ�sample_l��ѡ��
                        if obj.number_l<obj.number_h
                            error("�߾��ȳ�ʼ������������ڵ;����������޷�����ѡ�񣡣�����")
                        end
                        obj.points_h = obj.points_l;
                        for i=1:(obj.number_l - obj.number_h)
                            y = pdist(obj.points_h,'euclid');
                            z = linkage(y,'single');
                            p1 = z(1,1);%������ӽ���������֮һ
                            p2 = z(1,2);%������ӽ���������֮һ
                            d1 = sum((obj.points_h(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                            d2 = sum((obj.points_h(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                            
                            if d1<d2%ѡ���������Զ����һ��ȥ��
                                p = p2;
                            else
                                p = p1;
                            end
                            
                            obj.points_h(p,:) = [];%ȥ����p����
                            %obj.points_h = [obj.points_h(1:p-1,:);obj.points_h(p+1:end,:)];
                        end
                        
                        a = obj.points_h;
                        b = 1: obj.initial_num_h;
                        for k= 1:obj.initial_num_h
                            b(k) = Testmodel(a(k,:),obj.functype);
                        end
                        obj.values_h = b';%�����Ϊֱ�������һ��֮��ľ���
                        
                end
                %�Ը��ĺ�������������ܶ�
                obj.get_density;
                obj.get_start;
            end
        end%construct
        
        %==============================================================================
        %         function set.errtype(obj,val)
        %             if val==1 ||  val==2 ||val==5 ||val==6 ||val==3 ||val==4
        %                 obj.errtype = val;
        %                 %fprintf("�Ѿ���������Ϊ%s״̬",num2str(val));
        %             else
        %                 error("����û��%s����",num2str(val));
        %             end
        %         end
        
        %         function set.A(obj,val)
        %             if val>=0.1 || val<=5
        %                 obj.A = val;
        %                 %fprintf("�Ѿ����;��Ⱥ���ϵ����Ϊ%s״̬",num2str(val));
        %             else
        %                 error("�;��Ⱥ���ϵ��û��%s����",num2str(val));
        %             end
        %         end
        %================================================================================
        
        %denpendent
        function number = get.number(obj)
            number = obj.number_l + obj.number_h;
        end
        
        function points = get.points(obj)
            if isempty(obj.points_l)==1
                points=obj.points_h;
            elseif isempty(obj.points_h)==1
                points=obj.points_l;
            else
                points = cell(2,1);
                points{1,1} = obj.points_l;
                points{2,1} = obj.points_h;
            end
        end
        
        function values = get.values(obj)
            if isempty(obj.points_l)==1
                values=obj.values_h;
            elseif isempty(obj.points_h)==1
                values=obj.values_l;
            else
                values = cell(2,1);
                values{1,1} = obj.values_l;
                values{2,1} = obj.values_h;
            end
        end
        
        %===============================================================================
        
        %update
        %���ֻ��һ��ӵ㣬Ĭ�ϸ��߾��ȼӵ�
        %���������ӵ㣬ǰ��Ϊ�;��ȣ�����Ϊ�߾���
        %2019-5-14����һ�ָ��·�ʽ
        function update(obj,add1,add2)%����x��Ҫ��һ��������
            all=0;%����Ƿ�Ϊ���ں������ڵĹ�������
            if strcmp(obj.samtype,'high') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                [n_h,m] = size(ad_h);
                n_l = 0;
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('��������ά������')
                elseif m==obj.dimension+1
                    % disp('����Ϊ��������');
                    all=1;
                end
                
                
                
            elseif strcmp(obj.samtype,'low') && nargin==2
                ad_l = add1;
                ad_h = [];
                
                [n_l,m] = size(ad_l);
                n_h = 0;
                
                if m~=obj.dimension
                    error('��������ά������')
                elseif m==obj.dimension+1
                    disp('����Ϊ��������');
                    all=1;
                end
                
            elseif strcmp(obj.samtype,'mult') && nargin==3
                ad_l = add1;
                ad_h = add2;
                
                
                [n_h,m] = size(ad_h);
                if m==0
                    [n_h,~] = size(ad_h);
                    [~,m] = size(ad_l);
                end
                
                n_l = size(ad_l,1);
                
                if m~=obj.dimension
                    error('��������ά������')
                elseif m==obj.dimension+1
                    % disp('����Ϊ��������');
                    all=1;
                end
                
                %===================================================
            elseif strcmp(obj.samtype,'mult') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                
                [n_h,m] = size(ad_h);
                if m==0
                    [n_h,~] = size(ad_h);
                    [~,m] = size(ad_l);
                end
                
                n_l = size(ad_l,1);
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('��������ά������')
                elseif m==obj.dimension+1
                    disp('����Ϊ��������');
                    all=1;
                end
                %================================================
            elseif strcmp(obj.samtype,'nash') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                [n_h,m] = size(ad_h);
                n_l = 0;
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('��������ά������')
                elseif m==obj.dimension+1
                    disp('����Ϊ��������');
                    all=1;
                end
                
            else
                error('update������������淶�����飡����������')
                
                
            end
            %��Ҫ����ĵ��Ƚ��м��飬ȥ��̫���ĵ�
            %         for i=1:n
            %             e=sample(i,1:m)-add;
            %             if (min(abs(e))>0.01)
            %
            %             else
            %                 add=add+rand(1,m)*0.02-linspace(0.01,0.01,m)+0.01*(linspace(0.5,0.5,m)-add);
            %                 i=1;
            %             end
            %         end
            
            %���;������������
            switch all
                case 0
                    %����;�������
                    obj.points_l = [obj.points_l;ad_l];
                    %����;�������λ��
                    b = 1:n_l;
                    for k = 1:n_l
                        %                 b(k) = Testmodel(ad_l(k,:),obj.functype);
                        %                 b(k) = b(k) + Errormodel(ad_l(k,:),obj.errtype);
                        %                 b(k) = b(k)/obj.A;
                        %b(k) =Errormodel(ad_l(k,:),obj.errtype);
                        b(k) =Errormodel_dynamic(ad_l(k,:),obj.functype,obj.errtype,obj.errpara);
                    end
                    obj.values_l = [obj.values_l;b'];
                    
                    
                    %���߾������������
                    obj.points_h = [obj.points_h;ad_h];
                    b = 1:n_h;
                    for k = 1:n_h
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if strcmp(obj.samtype,'nash')%2019-7-7�����nash�Ĳ��ֽ�ȥ
                            temp = obj.global_elite;
                            temp(obj.subset) = ad_h(k,:);
                            b(k) = Testmodel_nash(temp,obj.functype);%%�ؼ�λ��
                        else
                            b(k) = Testmodel(ad_h(k,:),obj.functype);%%�ؼ�λ��
                            
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    end
                    obj.values_h = [obj.values_h;b'];
                    
                    
                    
                case 1
                    if isempty(ad_l)==0
                        obj.points_l = [obj.points_l;ad_l(:,1:obj.dimension)];
                        obj.values_l = [obj.values_l;ad_l(:,obj.dimension+1)];
                    end
                    
                    obj.points_h = [obj.points_h;ad_h(:,1:obj.dimension)];
                    obj.values_h = [obj.values_h;ad_h(:,obj.dimension+1)];
                    
                    
            end
            
            
            [obj.number_l,~] = size(obj.points_l);
            [obj.number_h,~] = size(obj.points_h);
            
            
            %����������һ
            obj.gen = obj.gen+1;
            
            %�Ը��ĺ�������������ܶ�
            %obj.get_density;
            %obj.get_start;
            
        end
        %===============================================================================
        function put_in(obj,type,add) %�ڷǵ��������֮�¼��������㣬���ö��ּ��뷽ʽ
            %һ��ֻ�ܼ���һ��
            switch type
                case 'low'
                    obj.samtype = 'mult' ;%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    obj.points_l = [obj.points_l;add];
                    n_l = size(add,1);
                    b = 1:n_l;
                    for k = 1:n_l
                        %                 b(k) = Testmodel(ad_l(k,:),obj.functype);
                        %                 b(k) = b(k) + Errormodel(ad_l(k,:),obj.errtype);
                        %                 b(k) = b(k)/obj.A;
                        %b(k) =Errormodel(add(k,:),obj.errtype);
                        b(k) = Errormodel_dynamic(add(k,:),obj.functype,obj.errtype,obj.errpara);%��̬�;���
                    end
                    obj.values_l = [obj.values_l;b'];
                    [obj.number_l,~] = size(obj.points_l);
                    
                    
                case 'high'
                    obj.points_h = [obj.points_h;add];%����λ��
                    n_h = size(add,1);
                    b = 1:n_h;
                    for k = 1:n_h
                        b(k) = Testmodel(add(k,:),obj.functype);
                        
                    end
                    obj.values_h = [obj.values_h;b'];%����ֵ
                    
                    [obj.number_h,~] = size(obj.points_h);%�޸�����
                    
                case 'high_from_low'
                    %%%%%
                    obj.number_h = add;
                    obj.points_h = obj.points_l;
                    for i=1:(obj.number_l - obj.number_h)
                        y = pdist(obj.points_h,'euclid');
                        z = linkage(y,'single');
                        p1 = z(1,1);%������ӽ���������֮һ
                        p2 = z(1,2);%������ӽ���������֮һ
                        
                        d1 = sum((obj.points_h(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                        d2 = sum((obj.points_h(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                        
                        if d1<d2%ѡ���������Զ����һ��ȥ��
                            p = p2;
                        else
                            p = p1;
                        end
                        
                        obj.points_h(p,:) = [];%ȥ����p����
                        %obj.points_h = [obj.points_h(1:p-1,:);obj.points_h(p+1:end,:)];
                    end
                    
                    a = obj.points_h;
                    b = 1: add;
                    for k= 1:add
                        b(k) = Testmodel(a(k,:),obj.functype);
                    end
                    obj.values_h = b';%�����Ϊֱ�������һ��֮��ľ���
                    
                case 'high_low_best'
                    
                case 'all_h'
                    add_p = add(:,1:size(add,2)-1);
                    add_v = add(:,size(add,2));
                    obj.points_h = [obj.points_h;add_p];%����λ��
                    n_h = size(add,1);
                    
                    obj.values_h = [obj.values_h;add_v];%����ֵ
                    
                    [obj.number_h,~] = size(obj.points_h);%�޸�����
                    
                case 'all_l'
                    add_p = add(:,1:size(add,2)-1);
                    add_v = add(:,size(add,2));
                    obj.points_l = [obj.points_l;add_p];%����λ��
                    n_l = size(add,1);
                    
                    obj.values_l = [obj.values_l;add_v];%����ֵ
                    
                    [obj.number_l,~] = size(obj.points_l);%�޸�����
            end
        end
        %=============================================================================
        %�ֲ�kriging��������
        function ratio_line = get.ratio_line(obj)
            ratio_line = obj.ratio^(1/obj.dimension);
        end
        
        function get_density(obj)%����
            obj.density = zeros(obj.number_h,1);
            for i=1:obj.number_h
                k = 0;
                for j= 1:obj.number_h
                    if max(abs(obj.points_h(i,:)-obj.points_h(j,:))) <= 0.5*obj.ratio_line
                        k = k+1;
                    end
                end
                obj.density(i)=k;
                
            end
        end
        
        
        function get_start(obj)
            temp = obj.start_local;
            if max(obj.density)>= obj.local_num
                
                p = find(max(obj.density)==obj.density);%������ܻ��ҵ�������ܶ���ͬ
                if size(p,1) > 1
                    for i=1:size(p,1)
                        q(i) = obj.values_h(p(i,:),:);
                    end
                    p = p(min(q)==q,:);
                end
                obj.center_point = obj.points_h(p,:);%�������ĵ�����ڿ�����Ե������������Ӧ�淶Χ������Ҫ��������
                
                for i=1:obj.dimension
                    obj.center_point(i) = max(min(obj.center_point(i),1-0.5*obj.ratio_line),0.5*obj.ratio_line);
                end
                
                obj.start_local = 1;
                if  temp+obj.start_local==1
                    disp("�ֲ���Ӧ�濪ʼ����");
                end
                %����Ӧ�ĵ����..._local��
                obj.number_local = max(obj.density);
                obj.points_local = [];
                obj.values_local = [];
                for i=1:obj.number_h
                    if  max(abs(obj.points_h(i,:)-obj.points_h(p,:))) <= 0.5*obj.ratio_line
                        obj.points_local = [obj.points_local;obj.points_h(i,:)];
                        obj.values_local = [obj.values_local;obj.values_h(i,:)];
                    end
                end
                
            end
        end
        
        
        
        
    end
end


