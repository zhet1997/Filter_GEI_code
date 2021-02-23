clc;clear;
clu=0.1;
info = struct();%用于储存本次迭代的身份信息
info.cluster_density_hi = 0.1;
for test_time=1:10
    sam = Sample('mult','ackley',30,15);
    mod = oodacefit( sam.points, sam.values, struct());
    opt = Iteration(sam,mod);
    for iteration=1:50
        fprintf("这是第%d次迭代\n",iteration);
        %  [x,y]=opt.select_EI('high');
        [x,y]=opt.select_GEI('high');
        x0=x;
        x1=[];
        mmm = mean(opt.Sample.values_h(1:opt.Sample.initial_num_h));
        mm = sum(opt.Sample.values_h(opt.Sample.initial_num_h+1:end))+mmm;
        mm = mm/(opt.Sample.number_h-opt.Sample.initial_num_h+1);
        ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance()/opt.Model.GP{1}.getProcessVariance())+1);
        
        for i=1:size(y,1)
            if y(i)<opt.y_min*ww + mm*(1-ww)
                x1=[x1;x(i,:)];%筛选出，未聚类
            end
        end
        
        if size(x1,1)>1
            x2=opt.cluster(x1,0.05);%聚类完毕
        else
            
            x2=x1;
        end
        s=[];
        for ii=1:size(x2,1)
           a = x-x2(ii);
           s  = [s;find(a(:,1)==0)];
        end
        x0(s,:)=[];
        
        x0=opt.cluster(x0,0.05);
        opt.Update(x0,x2);
        
         opt.record;
        opt.result;
 
        if opt.Stop_error(0.1)==1
            break;
        end
        
        
        
    end
    
    
    algo_type ='CoKriging';
    func_name = 'ackley';
    add_type = 'Filter_GEI0.05';
    %初始加点
    ini_number = 15;
    % ini_number_l=99;
    %加点方法
    
    path1 = 'E:\ooDACE\DATA\databox_2019_8_21\';
    path2 = [func_name,'\',algo_type,'\'];
    file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(test_time),'.mat'];
    save([path1,path2,file_name]);
    disp('alredy save');
end