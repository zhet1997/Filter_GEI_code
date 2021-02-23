%2019-6-5
%本程序为使用优化加点准则augmented-EI的优化程序
clc;clear;


for test_time=2

sam = Sample('mult','ackley',30,15);
mod = krigingfamily( sam.points, sam.values,'CoKriging');
opt = Iteration(sam,mod);

for iteration=1:200
    fprintf("这是第%d次迭代\n",iteration);
    [x1,y1,z1,s1] = opt.select_EI('high');
    [x2,y2,z2,s2] = opt.select_EI('low');
  
    
    alpha_1 = 1/opt.cost;
    alpha_2 = sqrt(s1)/(abs(y1-y2)+sqrt(s2));
    z2 = z2*alpha_1*alpha_2;
    
    if z1>z2
       opt.Update([],x1);%加入高精度样本
    else
        opt.Update(x2,[]);%加入低精度样本
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
      add_type =  'augmented_EI';
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

    
