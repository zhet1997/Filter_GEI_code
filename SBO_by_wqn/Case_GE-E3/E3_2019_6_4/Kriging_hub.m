%2019-6-30
%用于hub截面的优化
%使用Kriging代理模型
%使用GEI加点准则
clc;clear;

path = 'D:\Users\ASUS\Desktop\迁移学习算例20190601\hub\';
file1 = 'ini_high_points_75.dat';
file2 = 'ini_high_values_75.dat';
points0_h = importdata([path,file1]);%载入坐标
values0_h = importdata([path,file2]);%载入样本值

file2 = 'iter_new_points_k.dat';
file3 = 'iter_new_values_k.dat';
points_h = importdata([path,file2]) ;
values_h = importdata([path,file3]);%载入样本值


data_h = [points0_h,values0_h;points_h,values_h];


sam = Sample('high','E3',0);
sam.put_in('all_h',data_h);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

[x,y]=opt.select_GEI('high');
x0=opt.cluster(x,0.01);


 wdat([points_h;x0],[path,file2])%这是整个写入，而非在后面加上

  