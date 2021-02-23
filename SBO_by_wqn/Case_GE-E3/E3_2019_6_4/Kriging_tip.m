%2019_6_4
%用了MAP求解器
%用于tip响应面的建立

clc;clear;
path = 'D:\Users\ASUS\Desktop\迁移学习算例20190601\tip\';
file1 = 'ini_points_210.dat';
file2 = 'ini_values_210.dat';
points0 = importdata([path,file1]);%载入坐标
values0 = importdata([path,file2]);%载入样本值

% path = 'D:\Users\ASUS\Desktop\迁移学习算例20190601\CFX结果\';
% file3 = 'hub\ini_values_210.dat';
% file4 = 'tip\ini_values_210.dat';
% values_h = importdata([path,file3]);%载入坐标
% values_t = importdata([path,file4]);%载入样本值

file1 = 'iter_points.dat';
file2 = 'iter_values.dat';
points1 = importdata([path,file1]);%载入坐标
values1 = importdata([path,file2]);%载入样本值


data = [points0,values0;points1,values1];
sam = Sample('high','E3',0);
sam.put_in('all_h',data);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

%[x,y]=opt.select_GEI('high');
%x = opt.cluster(x,0.01);
save('D:\Users\ASUS\Desktop\迁移学习算例20190601\opt_tip.mat','opt_tip_271')
  