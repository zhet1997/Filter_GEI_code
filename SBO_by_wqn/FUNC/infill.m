%2019-8-29
function [x_l,x_h] = infill(opt,option)

switch option.infill
    case 'VF_EI'
        [x,~,~,~,l] = opt.select_VF_EI();
        if l==2
            x_h = x;
            x_l =[];
        elseif l==1
            x_h = [];
            x_l =x;
        end
    case 'augmented_EI'
        [x1,y1,z1,s1] = opt.select_EI('high');
        [x2,y2,z2,s2] = opt.select_EI('low');
        
        alpha_1 = 1/opt.cost;
        alpha_2 = sqrt(s1)/(abs(y1-y2)+sqrt(s2));
        z2 = z2*alpha_1*alpha_2;
        
        if z1>z2
            x_h = x1;
            x_l = [];
        else
            x_h = [];
            x_l = x2;
        end
    case 'Filter_GEI'
        [x,y]=opt.find_GEI(10);
        x0=x;
        x1=[];
        %         mm_ini = mean(opt.Sample.values_h(1:opt.Sample.initial_num_h));%初始加点平均数
        %         mm = sum(opt.Sample.values_h(opt.Sample.initial_num_h+1:end))+mm_ini;
        %         mm = mm/(opt.Sample.number_h-opt.Sample.initial_num_h+1);
        idx1 = cumsum(opt.add_record,1);
        idx2 = [0;idx1(1:end-1,2)]+1;
        idx2 = [idx2,idx1(:,2)];
        mm=[];
        for ii=1:opt.Sample.gen+1
            if idx2(ii,1)<=idx2(ii,2)
                mm = [mm;mean(opt.Sample.values_h(idx2(ii,1):idx2(ii,2)))];
            end
        end
        mm = mean(mm);
        ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance()/opt.Model.GP{1}.getProcessVariance())+1);
        
        for i=1:size(y,1)
            if y(i) <= opt.y_min*ww + mm*(1-ww)
                x1=[x1;x(i,:)];%筛选出，未聚类
            end
        end
        
        if size(x1,1)>1
            x2=opt.cluster2(x1,option.cluster_h*sqrt(opt.Sample.dimension));%聚类完毕
        else
            x2=x1;
        end
        
        s=[];
        for ii=1:size(x2,1)
            a = x-x2(ii);
            s  = [s;find(a(:,1)==0)];
        end
        x0(s,:)=[];
        
        x0=opt.cluster3(x0,option.cluster_l*sqrt(opt.Sample.dimension));
        
        x_h = x2;
        x_l = x0;
        
    case 'EI'
        [x_h] = opt.select_EI('high');
        if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')
           x_l = x_h;
        elseif  strcmp(option.model,'Kriging')==1
           x_l = [];
        else
            error('输入的方法不在可选范围内');
        end
    case 'GEI'
        [x] = opt.select_GEI('high');
        x_h = opt.cluster(x,option.cluster_h*sqrt(opt.Sample.dimension) );
        if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')
            x_l =opt.cluster(x,option.cluster_l*sqrt(opt.Sample.dimension));
        elseif  strcmp(option.model,'Kriging')==1
           x_l = [];
        else
            error('输入的方法不在可选范围内');
        end
        
end

