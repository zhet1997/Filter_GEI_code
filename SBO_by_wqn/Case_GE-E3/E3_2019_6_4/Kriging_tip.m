%2019_6_4
%����MAP�����
%����tip��Ӧ��Ľ���

clc;clear;
path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190601\tip\';
file1 = 'ini_points_210.dat';
file2 = 'ini_values_210.dat';
points0 = importdata([path,file1]);%��������
values0 = importdata([path,file2]);%��������ֵ

% path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190601\CFX���\';
% file3 = 'hub\ini_values_210.dat';
% file4 = 'tip\ini_values_210.dat';
% values_h = importdata([path,file3]);%��������
% values_t = importdata([path,file4]);%��������ֵ

file1 = 'iter_points.dat';
file2 = 'iter_values.dat';
points1 = importdata([path,file1]);%��������
values1 = importdata([path,file2]);%��������ֵ


data = [points0,values0;points1,values1];
sam = Sample('high','E3',0);
sam.put_in('all_h',data);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

%[x,y]=opt.select_GEI('high');
%x = opt.cluster(x,0.01);
save('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190601\opt_tip.mat','opt_tip_271')
  