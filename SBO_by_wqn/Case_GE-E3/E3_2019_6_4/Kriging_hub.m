%2019-6-30
%����hub������Ż�
%ʹ��Kriging����ģ��
%ʹ��GEI�ӵ�׼��
clc;clear;

path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190601\hub\';
file1 = 'ini_high_points_75.dat';
file2 = 'ini_high_values_75.dat';
points0_h = importdata([path,file1]);%��������
values0_h = importdata([path,file2]);%��������ֵ

file2 = 'iter_new_points_k.dat';
file3 = 'iter_new_values_k.dat';
points_h = importdata([path,file2]) ;
values_h = importdata([path,file3]);%��������ֵ


data_h = [points0_h,values0_h;points_h,values_h];


sam = Sample('high','E3',0);
sam.put_in('all_h',data_h);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

[x,y]=opt.select_GEI('high');
x0=opt.cluster(x,0.01);


 wdat([points_h;x0],[path,file2])%��������д�룬�����ں������

  