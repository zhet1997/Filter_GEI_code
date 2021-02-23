%2019-10-25
%这一算例的目的是探索初始样本分布变化对代理模型造成的影响。
%用GE-E3第一级静叶中间截面在不同出口马赫数下的能量损失系数响应面来作为测试函数

%总是以0.6响应面作为高精度响应面
%分别以其他五个响应面作为低精度响应面

%初始加点总是为30，加点方式为优化LHS
%提前准备10组LHS数据备用
%迭代20步
%==========================================================================
clc;clear;
%读取与储存路径
path1 = 'D:\Users\ASUS\Desktop\迁移学习算例20191025\surf\';%响应面数据来源
path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20191025\';%初始样本位置
path3 = 'D:\Users\ASUS\Desktop\迁移学习算例20191025\completed_task\';%结果储存位置
%参数选择

for func = [0.7,0.8,0.9,1.0,1.1] 
 sample50 = cell(1,10);
for time = 1:10
    
inform.func=func;
inform.time = time;

%加载响应面mat文件
load([path1,'res_surf',num2str(func),'.mat'],'mod');
fun_h = mod;
clear('mod');
%加载LHS分布文件
load([path2,'sample30.mat']);
%初始采样
points = ini_sample_box{1,time};
values = fun_h.predict(points);
%建立初始响应面，计算初始响应面精度
%储存结果
sam = Sample('high','E3',0);
sam.put_in('all_h',[points,values]);
mod = krigingfamily( sam.points, sam.values,'Kriging');
%mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

%开始EI迭代20步
for iteration=1:20
%    fprintf("这是第%d次迭代\n",iteration);
    [x1] = opt.select_EI('high');
    y1 = fun_h.predict(x1);
    opt.Update([x1,y1]);
    opt.record;
    opt.result; 
    
%     if opt.best_value<=0.0353
%          break;
%      end
    
end

%储存结果
save([path3,num2str(inform.func),'_',num2str(time),'.mat'],'opt','inform');
sample50{1,time} = opt.Sample.points_h;
end
save([path2,'sample/',num2str(inform.func),'.mat'],'sample50');
end







