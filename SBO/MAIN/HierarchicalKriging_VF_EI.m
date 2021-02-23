%2019-8-21
%本程序为使用优化加点准则augmented-EI的优化程序
clc;clear;


for test_time=1:10

sam = Sample('mult','ackley',50,25);
mod = GPfamily( sam.points, sam.values,'HierarchicalKriging');
opt = Iteration(sam,mod);

for iteration=1:500
    fprintf("这是第%d次迭代\n",iteration);
    [x1,y1,z1,s1,l] = opt.select_VF_EI();
 

    
    if l==2
       opt.Update([],x1);%加入高精度样本
    elseif l==1
        opt.Update(x1,[]);%加入低精度样本
    end

    
    opt.record;
    opt.result;
    
    %         if opt.Stop_EImax==1%跳出方法
    %             break;
    %         end
    %         if opt.Stop_sla==1
    %             break;
    %         end
     if opt.Stop_error(0.1)==1
         break;
     end


    
end


  algo_type ='CoKriging';
     func_name = 'ackley';
      add_type = 'VF_EI';
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

