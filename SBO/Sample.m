
%Input：1.testfunction；2.number of initial samples-n；3.the boundary of design space；

%1：forrester
%2：branin
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
        
        way=1;%how to get the high-fidelity samples
    end
    
    properties(Dependent)
        number
        points
        values
        
    end
    
    
    properties(Hidden)
        number_local
        points_local
        values_local
    end
    
    %===============================================================================
    methods
        %===============================================================================
        function obj=Sample(samtype,functype,errtype,errpara,ini1,ini2)%%construct
            
            if strcmp(samtype,'high') && nargin==3
                obj.initial_num_l = [];
                %obj.initial_num_h = ini1;
                obj.initial_num_h = errtype;%
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
                
            elseif strcmp(samtype,'mult') && nargin==4
                obj.initial_num_l = errtype;
                obj.initial_num_h = errpara;
                
                obj.number_l = errtype;
                obj.number_h = errpara;
                
                obj.errpara = errpara;
                obj.errtype =errtype;
                %===========================================
            else
                error('Irregular input, check please!')
                
                
            end
            
            switch functype %dimention of different test functions
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
            end
            
            obj.samtype = samtype;
            obj.functype = functype;
            
            if isempty(obj.initial_num_l)==0%
                ad=3;
                obj.points_l=lhsdesign(obj.initial_num_l*ad, obj.dimension);
                
                
                for i=1:obj.number_l*(ad-1)
                    y = pdist(obj.points_l,'euclid');
                    z = linkage(y,'single');
                    p1 = z(1,1);
                    p2 = z(1,2);
                    d1 = sum((obj.points_l(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                    d2 = sum((obj.points_l(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                    
                    if d1<d2%get rid of the sample futher from the center of design space
                        p = p2;
                    else
                        p = p1;
                    end
                    
                    obj.points_l(p,:) = [];
                end
                
                
                a=obj.points_l;
                b=1: obj.initial_num_l;
                for k= 1:obj.initial_num_l
                    b(k) = Errormodel_dynamic(a(k,:),obj.functype,obj.errtype,obj.errpara);%动态低精度
                end
                obj.values_l=b';
                
                
                obj.way = 2;
            end
            
            
            if isempty(obj.initial_num_h)==0
                switch obj.way
                    case 1%independent with low-fidelity sampling
                        
                        obj.points_h = lhsdesign(obj.initial_num_h, obj.dimension);
                        a = obj.points_h;
                        b = 1: obj.initial_num_h;
                        for k= 1:obj.initial_num_h
                            b(k) = Testmodel(a(k,:),obj.functype);
                        end
                        obj.values_h = b';
                        
                        
                    case 2%%dependent by low-fidelity sampling
                        if obj.number_l<obj.number_h
                            error("高精度初始样本点个数多于低精度样本，无法进行选择！！！！")
                        end
                        obj.points_h = obj.points_l;
                        for i=1:(obj.number_l - obj.number_h)
                            y = pdist(obj.points_h,'euclid');
                            z = linkage(y,'single');
                            p1 = z(1,1);
                            p2 = z(1,2);
                            d1 = sum((obj.points_h(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                            d2 = sum((obj.points_h(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                            
                            if d1<d2
                                p = p2;
                            else
                                p = p1;
                            end
                            obj.points_h(p,:) = [];
                        end
                        
                        a = obj.points_h;
                        b = 1: obj.initial_num_h;
                        for k= 1:obj.initial_num_h
                            b(k) = Testmodel(a(k,:),obj.functype);
                        end
                        obj.values_h = b';
                        
                end
            end
        end%construct
        
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
        
        function update(obj,add1,add2)
            all=0;
            if strcmp(obj.samtype,'high') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                [n_h,m] = size(ad_h);
                n_l = 0;
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('vector input with wrong dimension')
                elseif m==obj.dimension+1
                    all=1;
                end
                
                
                
            elseif strcmp(obj.samtype,'low') && nargin==2
                ad_l = add1;
                ad_h = [];
                
                [n_l,m] = size(ad_l);
                n_h = 0;
                
                if m~=obj.dimension
                    error('vector input with wrong dimension')
                elseif m==obj.dimension+1
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
                    error('vector input with wrong dimension')
                elseif m==obj.dimension+1
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
                    error('vector input with wrong dimension')
                elseif m==obj.dimension+1
                    all=1;
                end
                %================================================
            elseif strcmp(obj.samtype,'nash') && nargin==2
                ad_l = [];
                ad_h = add1;
                
                [n_h,m] = size(ad_h);
                n_l = 0;
                
                if m~=obj.dimension && m~=obj.dimension+1
                    error('vector input with wrong dimension')
                elseif m==obj.dimension+1
                    all=1;
                end
                
            else
                error('update：illeagle input, check please!')
                
                
            end
            
            switch all
                case 0
                    obj.points_l = [obj.points_l;ad_l];
                    b = 1:n_l;
                    for k = 1:n_l
                        b(k) =Errormodel_dynamic(ad_l(k,:),obj.functype,obj.errtype,obj.errpara);
                    end
                    obj.values_l = [obj.values_l;b'];
                    
                    
                    obj.points_h = [obj.points_h;ad_h];
                    b = 1:n_h;
                    for k = 1:n_h
                        b(k) = Testmodel(ad_h(k,:),obj.functype);
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
            obj.gen = obj.gen+1;
            
            
        end
        %===============================================================================
        function put_in(obj,type,add)
            switch type
                case 'low'
                    obj.samtype = 'mult' ;
                    obj.points_l = [obj.points_l;add];
                    n_l = size(add,1);
                    b = 1:n_l;
                    for k = 1:n_l
                        b(k) = Errormodel_dynamic(add(k,:),obj.functype,obj.errtype,obj.errpara);%动态低精度
                    end
                    obj.values_l = [obj.values_l;b'];
                    [obj.number_l,~] = size(obj.points_l);
                    
                    
                case 'high'
                    obj.points_h = [obj.points_h;add];
                    n_h = size(add,1);
                    b = 1:n_h;
                    for k = 1:n_h
                        b(k) = Testmodel(add(k,:),obj.functype);
                        
                    end
                    obj.values_h = [obj.values_h;b'];
                    [obj.number_h,~] = size(obj.points_h);
                case 'high_from_low'
                    obj.number_h = add;
                    obj.points_h = obj.points_l;
                    for i=1:(obj.number_l - obj.number_h)
                        y = pdist(obj.points_h,'euclid');
                        z = linkage(y,'single');
                        p1 = z(1,1);
                        p2 = z(1,2);
                        
                        d1 = sum((obj.points_h(p1,:) - linspace(0.5,0.5,obj.dimension)).^2);
                        d2 = sum((obj.points_h(p2,:) - linspace(0.5,0.5,obj.dimension)).^2);
                        
                        if d1<d2
                            p = p2;
                        else
                            p = p1;
                        end
                        
                        obj.points_h(p,:) = [];
                        
                    end
                    
                    a = obj.points_h;
                    b = 1: add;
                    for k= 1:add
                        b(k) = Testmodel(a(k,:),obj.functype);
                    end
                    obj.values_h = b';
                    
                case 'high_low_best'
                    
                case 'all_h'
                    add_p = add(:,1:size(add,2)-1);
                    add_v = add(:,size(add,2));
                    obj.points_h = [obj.points_h;add_p];
                    n_h = size(add,1);
                    
                    obj.values_h = [obj.values_h;add_v];
                    
                    [obj.number_h,~] = size(obj.points_h);
                    
                case 'all_l'
                    add_p = add(:,1:size(add,2)-1);
                    add_v = add(:,size(add,2));
                    obj.points_l = [obj.points_l;add_p];
                    n_l = size(add,1);
                    
                    obj.values_l = [obj.values_l;add_v];
                    
                    [obj.number_l,~] = size(obj.points_l);
            end
        end
        
        
    end
end


