%2019_5_15
%用于tip响应面的建立

clc;clear;
path = 'D:\Users\ASUS\Desktop\迁移学习算例\tip\';
file1 = 'ini_points_210.dat';
file2 = 'ini_values_210.dat';
points0 = importdata([path,file1]);%载入坐标
values0 = importdata([path,file2]);%载入样本值

file1 = 'iter1_points_6.dat';
file2 = 'iter1_values_6.dat';
points1 = importdata([path,file1]);%载入坐标
values1 = importdata([path,file2]);%载入样本值

file1 = 'iter2_points_7.dat';
file2 = 'iter2_values_7.dat';
points2 = importdata([path,file1]);%载入坐标
values2 = importdata([path,file2]);%载入样本值

file1 = 'iter3_points_5.dat';
file2 = 'iter3_values_5.dat';
points3 = importdata([path,file1]);%载入坐标
values3 = importdata([path,file2]);%载入样本值

file1 = 'iter4_points_8.dat';
file2 = 'iter4_values_8.dat';
points4 = importdata([path,file1]);%载入坐标
values4 = importdata([path,file2]);%载入样本值

file1 = 'iter5_points_9.dat';
file2 = 'iter5_values_9.dat';
points5 = importdata([path,file1]);%载入坐标
values5 = importdata([path,file2]);%载入样本值

file1 = 'iter6_points_9.dat';
file2 = 'iter6_values_9.dat';
points6 = importdata([path,file1]);%载入坐标
values6 = importdata([path,file2]);%载入样本值

file1 = 'iter7_points_9.dat';
file2 = 'iter7_values_9.dat';
points7 = importdata([path,file1]);%载入坐标
values7 = importdata([path,file2]);%载入样本值

file1 = 'iter8_points_6.dat';
file2 = 'iter8_values_6.dat';
points8 = importdata([path,file1]);%载入坐标
values8 = importdata([path,file2]);%载入样本值

data = [points0,values0;points1,values1;points2,values2;points3,values3;points4,values4;points5,values5;points6,values6;points7,values7;points8,values8];
sam = Sample('high','E3',0);
sam.put_in('all',data);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);
  