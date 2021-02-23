%2019-5-6
%这个程序为局部kriging_2的主程序
%局部kriging_1的特征是：1局部响应面的大小会发生变化；
                      %2局部响应面从始至终存在；
                      %3只有一个局部响应面；
                      %4局部响应面的作用是加快局部收敛；
%要实现局部kriging,还需要在Sample中添加一个选择点密度最大位置的函数；
%还需要在Iteration中添加一个只对局部区域进行搜索的函数；
%最好还能加一个对两种响应面吻合程度进行评估的函数

clc;clear;
%==========================================================================
%取初始样本点,并建立响应面
    sam = Sample('mult','branin',20,3);
    opts = struct();
    mod = oodacefit( sam.points, sam.values, opts );
    opt = Iteration(sam,mod);
    
    for iteration=1:100
        fprintf("这是第%d次迭代\n",iteration);
        x=opt.select_EI('high');
      
      
       
        
        opt.Update(x,x);
        
 
        opt.record;
        opt.result;
        
    end   