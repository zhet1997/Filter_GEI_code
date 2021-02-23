%2019-6-29
%用于hub截面的优化
%使用Cokriging代理模型
%使用GEI加点准则
clc;clear;
load('D:\Users\ASUS\Desktop\迁移学习算例20190601\opt_tip.mat');%载入已经构建完成的tip响应面

path = 'D:\Users\ASUS\Desktop\迁移学习算例20190601\hub\';
file1 = 'ini_high_points_75.dat';
file2 = 'ini_high_values_75.dat';
points0_h = importdata([path,file1]);%载入坐标
values0_h = importdata([path,file2]);%载入样本值

file2 = 'iter_new_points_h.dat';
file3 = 'iter_new_values_h.dat';
points_h = importdata([path,file2]) ;
values_h = importdata([path,file3]);%载入样本值


data_h = [points0_h,values0_h;points_h,values_h];
data_l = [opt_tip_271.Sample.points,opt_tip_271.Sample.values];

sam = Sample('mult','E3',0,0);
sam.put_in('all_h',data_h);
sam.put_in('all_l',data_l);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

[x,y]=opt.select_GEI('high');
x0=opt.cluster(x,0.01);

  