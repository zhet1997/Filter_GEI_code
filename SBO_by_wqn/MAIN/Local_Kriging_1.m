%2019-5-6
%这个程序为局部kriging_1的主程序
%局部kriging_1的特征是：1局部响应面的大小不发生变化；
                      %2局部响应面在一定数量迭代之后才出现
                      %3可以同时存在多个局部响应面
                      %4局部响应面的作用是加快局部收敛
%要实现局部kriging,还需要在Sample中添加一个选择点密度最大位置的函数；
%还需要在Iteration中添加一个只对局部区域进行搜索的函数；
%最好还能加一个对两种响应面吻合程度进行评估的函数

clc;clear;
%==========================================================================
%取初始样本点,并建立响应面
for test_time = 2:1:5
    sam = Sample('mult','hartmann_3D',18,9);
    mod = oodacefit( sam.points, sam.values, struct());
    opt = Iteration(sam,mod);
    
    for iteration=1:50
        fprintf("这是第%d次迭代\n",iteration);
        x=opt.select_EI('high');   
        opt.Update(x,x);
        opt.record;
        opt.result;
%         if opt.Sample.start_local==1
%             break;
%         end
         if opt.Stop_error==1%跳出方法
            break;
        end
    end  
    
    

     algo_type ='CoKriging';
     func_name = 'hartmann_3D';
      add_type = 'EI';
                %初始加点
                ini_number = 9;
               % ini_number_l=99;
                %加点方法

 path1 = 'E:\ooDACE\Append_by_wqn\databox_2019_5_10\';
 path2 = [func_name,'\',algo_type,'\'];
 file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(test_time),'.mat'];
            save([path1,path2,file_name]);
            disp('alredy save');
end