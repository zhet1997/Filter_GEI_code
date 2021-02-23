%2019-3-11
%这个程序的作用是在给定测试函数的前提下，通过拉丁超立方选择样本点
%输入：1.测试函数（m维）；2.样本点个数n；3.取样区域（2*m矩阵）；
%此函数之针对CoKrigingsho
%1：forrester函数
%2：branin函数
%3hartmann-3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at（4,4,4,4）
classdef Sample<handle
    properties
        samtype
        functype
        gen=0;
        dimension
    end
    
    properties %low_fidelity
        initial_num_l  %最初加点数
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
        
        way=1;%高精度点的取样方法
    end
    
    properties(Dependent)
        number
        points
        values
        
    end
    
    properties(Access = private)%与局部kriging_1相关的参数
        ratio=0.05;%局部响应面设计空间占整个设计空间的比例
        local_num=3;  %局部响应面内最少需要的样本数
        start_local=0; %判断是否建立局部响应面
        density
        center_point
    end
    
    properties(Dependent)
        ratio_line %在一个变量上的占比
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
                obj.initial_num_h = errtype;%随便写的。
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
                
            elseif strcmp(samtype,'mult') && nargin==4%工程算例，临时添加
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
                error('Sample类：输入参数不规范，请检查！！！！！！')
                
                
            end
            
            switch functype %确定各个函数的维度
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
                case 'E3'%2019-5-14%工程算例专用
                    obj.dimension =1;
                case 'XM'%2019-5-14%工程算例专用
                    obj.dimension =11;
                case 'E3_7'%2020-6-20%工程算例
                    obj.dimension =7;
            end
            
            obj.samtype = samtype;
            obj.functype = functype;
       
            if isempty(obj.initial_num_l)==0%检查算法类型
                %构造低精度样本集
                ad=3;
                obj.points_l=lhsdesign(obj.initial_num_l*ad, obj.dimension);%输出为n*m的矩阵
                
                
                for i=1:obj.number_l*(ad-1)
                    y = pdist(obj.points_l,'euclid');
                    z = linkage(y,'single');
                    p1 = z(1,1);%两个最接近的样本点之一
                    p2 = z(1,2);%两个最接近的样本点之一
                    d1 = sum((obj.points_l(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                    d2 = sum((obj.points_l(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                    
                    if d1<d2%选择距离中心远的那一个去除
                        p = p2;
                    else
                        p = p1;
                    end
                    
                    obj.points_l(p,:) = [];%去除第p个点
                    %obj.points_h = [obj.points_h(1:p-1,:);obj.points_h(p+1:end,:)];
                end
                
                
                a=obj.points_l;
                b=1: obj.initial_num_l;
                for k= 1:obj.initial_num_l
                    %                     b(k) = Testmodel(a(k,:),obj.functype);
                    %                     b(k) = b(k) + Errormodel(a(k,:),obj.errtype);
                    %                     b(k) = b(k)/obj.A;
                    %b(k) = Errormodel(a(k,:),obj.errtype);
                    b(k) = Errormodel_dynamic(a(k,:),obj.functype,obj.errtype,obj.errpara);%动态低精度
                end
                obj.values_l=b';%这里改为直接输出归一化之后的矩阵
                
                
                obj.way = 2;%如果有低精度初始加点，那么高精度从低精度中选择
            end
            
            %构造高精度样本集
            if isempty(obj.initial_num_h)==0%检查算法类型
                switch obj.way
                    case 1%独立构造
                        
                        obj.points_h = lhsdesign(obj.initial_num_h, obj.dimension);%输出为n*m的矩阵
                        a = obj.points_h;
                        b = 1: obj.initial_num_h;
                        for k= 1:obj.initial_num_h
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            if strcmp(obj.samtype,'nash')%2019-7-7添加了nash的部分进去
                                temp = obj.global_elite;
                                temp(obj.subset) = a(k,:);
                                b(k) = Testmodel_nash(temp,obj.functype);%%关键位置
                            else
                                b(k) = Testmodel(a(k,:),obj.functype);%%关键位置
                                
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        end
                        obj.values_h = b';%这里改为直接输出归一化之后的矩阵
                        
                        
                    case 2%直接从sample_l中选择
                        if obj.number_l<obj.number_h
                            error("高精度初始样本点个数多于低精度样本，无法进行选择！！！！")
                        end
                        obj.points_h = obj.points_l;
                        for i=1:(obj.number_l - obj.number_h)
                            y = pdist(obj.points_h,'euclid');
                            z = linkage(y,'single');
                            p1 = z(1,1);%两个最接近的样本点之一
                            p2 = z(1,2);%两个最接近的样本点之一
                            d1 = sum((obj.points_h(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                            d2 = sum((obj.points_h(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                            
                            if d1<d2%选择距离中心远的那一个去除
                                p = p2;
                            else
                                p = p1;
                            end
                            
                            obj.points_h(p,:) = [];%去除第p个点
                            %obj.points_h = [obj.points_h(1:p-1,:);obj.points_h(p+1:end,:)];
                        end
                        
                        a = obj.points_h;
                        b = 1: obj.initial_num_h;
                        for k= 1:obj.initial_num_h
                            b(k) = Testmodel(a(k,:),obj.functype);
                        end
                        obj.values_h = b';%这里改为直接输出归一化之后的矩阵
                        
                end
                %对更改后的样本集计算密度
                obj.get_density;
                obj.get_start;
            end
        end%construct
        
        %==============================================================================
        %         function set.errtype(obj,val)
        %             if val==1 ||  val==2 ||val==5 ||val==6 ||val==3 ||val==4
        %                 obj.errtype = val;
        %                 %fprintf("已经将变差函数改为%s状态",num2str(val));
        %             else
        %                 error("变差函数没有%s类型",num2str(val));
        %             end
        %         end
        
        %         function set.A(obj,val)
        %             if val>=0.1 || val<=5
        %                 obj.A = val;
        %                 %fprintf("已经将低精度函数系数改为%s状态",num2str(val));
        %             else
        %                 error("低精度函数系数没有%s类型",num2str(val));
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
        %如果只有一组加点，默认给高精度加点
        %如果有两组加点，前面为低精度，后面为高精度
        %2019-5-14增加一种更新方式
        function update(obj,add1,add2)%这里x需要是一个行向量
            all=0;%检查是否为不在函数表内的工程算例
            if strcmp(obj.samtype,'high') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                [n_h,m] = size(ad_h);
                n_l = 0;
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('输入坐标维数错误')
                elseif m==obj.dimension+1
                    % disp('输入为工程算例');
                    all=1;
                end
                
                
                
            elseif strcmp(obj.samtype,'low') && nargin==2
                ad_l = add1;
                ad_h = [];
                
                [n_l,m] = size(ad_l);
                n_h = 0;
                
                if m~=obj.dimension
                    error('输入坐标维数错误')
                elseif m==obj.dimension+1
                    disp('输入为工程算例');
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
                    error('输入坐标维数错误')
                elseif m==obj.dimension+1
                    % disp('输入为工程算例');
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
                    error('输入坐标维数错误')
                elseif m==obj.dimension+1
                    disp('输入为工程算例');
                    all=1;
                end
                %================================================
            elseif strcmp(obj.samtype,'nash') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                [n_h,m] = size(ad_h);
                n_l = 0;
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('输入坐标维数错误')
                elseif m==obj.dimension+1
                    disp('输入为工程算例');
                    all=1;
                end
                
            else
                error('update：输入参数不规范，请检查！！！！！！')
                
                
            end
            %对要加入的点先进行检验，去除太近的点
            %         for i=1:n
            %             e=sample(i,1:m)-add;
            %             if (min(abs(e))>0.01)
            %
            %             else
            %                 add=add+rand(1,m)*0.02-linspace(0.01,0.01,m)+0.01*(linspace(0.5,0.5,m)-add);
            %                 i=1;
            %             end
            %         end
            
            %将低精度样本点加入
            switch all
                case 0
                    %加入低精度坐标
                    obj.points_l = [obj.points_l;ad_l];
                    %计算低精度样本位置
                    b = 1:n_l;
                    for k = 1:n_l
                        %                 b(k) = Testmodel(ad_l(k,:),obj.functype);
                        %                 b(k) = b(k) + Errormodel(ad_l(k,:),obj.errtype);
                        %                 b(k) = b(k)/obj.A;
                        %b(k) =Errormodel(ad_l(k,:),obj.errtype);
                        b(k) =Errormodel_dynamic(ad_l(k,:),obj.functype,obj.errtype,obj.errpara);
                    end
                    obj.values_l = [obj.values_l;b'];
                    
                    
                    %将高精度样本点加入
                    obj.points_h = [obj.points_h;ad_h];
                    b = 1:n_h;
                    for k = 1:n_h
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if strcmp(obj.samtype,'nash')%2019-7-7添加了nash的部分进去
                            temp = obj.global_elite;
                            temp(obj.subset) = ad_h(k,:);
                            b(k) = Testmodel_nash(temp,obj.functype);%%关键位置
                        else
                            b(k) = Testmodel(ad_h(k,:),obj.functype);%%关键位置
                            
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
            
            
            %迭代次数加一
            obj.gen = obj.gen+1;
            
            %对更改后的样本集计算密度
            %obj.get_density;
            %obj.get_start;
            
        end
        %===============================================================================
        function put_in(obj,type,add) %在非迭代的情况之下加入样本点，设置多种加入方式
            %一次只能加入一种
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
                        b(k) = Errormodel_dynamic(add(k,:),obj.functype,obj.errtype,obj.errpara);%动态低精度
                    end
                    obj.values_l = [obj.values_l;b'];
                    [obj.number_l,~] = size(obj.points_l);
                    
                    
                case 'high'
                    obj.points_h = [obj.points_h;add];%加入位置
                    n_h = size(add,1);
                    b = 1:n_h;
                    for k = 1:n_h
                        b(k) = Testmodel(add(k,:),obj.functype);
                        
                    end
                    obj.values_h = [obj.values_h;b'];%加入值
                    
                    [obj.number_h,~] = size(obj.points_h);%修改数量
                    
                case 'high_from_low'
                    %%%%%
                    obj.number_h = add;
                    obj.points_h = obj.points_l;
                    for i=1:(obj.number_l - obj.number_h)
                        y = pdist(obj.points_h,'euclid');
                        z = linkage(y,'single');
                        p1 = z(1,1);%两个最接近的样本点之一
                        p2 = z(1,2);%两个最接近的样本点之一
                        
                        d1 = sum((obj.points_h(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                        d2 = sum((obj.points_h(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                        
                        if d1<d2%选择距离中心远的那一个去除
                            p = p2;
                        else
                            p = p1;
                        end
                        
                        obj.points_h(p,:) = [];%去除第p个点
                        %obj.points_h = [obj.points_h(1:p-1,:);obj.points_h(p+1:end,:)];
                    end
                    
                    a = obj.points_h;
                    b = 1: add;
                    for k= 1:add
                        b(k) = Testmodel(a(k,:),obj.functype);
                    end
                    obj.values_h = b';%这里改为直接输出归一化之后的矩阵
                    
                case 'high_low_best'
                    
                case 'all_h'
                    add_p = add(:,1:size(add,2)-1);
                    add_v = add(:,size(add,2));
                    obj.points_h = [obj.points_h;add_p];%加入位置
                    n_h = size(add,1);
                    
                    obj.values_h = [obj.values_h;add_v];%加入值
                    
                    [obj.number_h,~] = size(obj.points_h);%修改数量
                    
                case 'all_l'
                    add_p = add(:,1:size(add,2)-1);
                    add_v = add(:,size(add,2));
                    obj.points_l = [obj.points_l;add_p];%加入位置
                    n_l = size(add,1);
                    
                    obj.values_l = [obj.values_l;add_v];%加入值
                    
                    [obj.number_l,~] = size(obj.points_l);%修改数量
            end
        end
        %=============================================================================
        %局部kriging函数部分
        function ratio_line = get.ratio_line(obj)
            ratio_line = obj.ratio^(1/obj.dimension);
        end
        
        function get_density(obj)%计算
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
                
                p = find(max(obj.density)==obj.density);%这里可能会找到多个点密度相同
                if size(p,1) > 1
                    for i=1:size(p,1)
                        q(i) = obj.values_h(p(i,:),:);
                    end
                    p = p(min(q)==q,:);
                end
                obj.center_point = obj.points_h(p,:);%由于中心点可能在靠近边缘处，超出主响应面范围，所以要进行修正
                
                for i=1:obj.dimension
                    obj.center_point(i) = max(min(obj.center_point(i),1-0.5*obj.ratio_line),0.5*obj.ratio_line);
                end
                
                obj.start_local = 1;
                if  temp+obj.start_local==1
                    disp("局部响应面开始生成");
                end
                %将对应的点存入..._local中
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


