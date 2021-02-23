%2019-5-15
%����hub������Ż�
% clc;clear;
% load('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����\tip.mat');%�����Ѿ�������ɵ�tip��Ӧ��
% 
% path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����\hub\';
% file1 = 'ini_high_points_35.dat';
% file2 = 'ini_high_values_35.dat';
% points0_h = importdata([path,file1]);%��������
% values0_h = importdata([path,file2]);%��������ֵ

file1 = 'ini_low_points_105.dat';
file2 = 'ini_low_values_105.dat';
points0_l = importdata([path,file1]);%��������
values0_l = importdata([path,file2]);%��������ֵ

file1 = 'iter_new_points_l.dat';
file2 = 'iter_new_points_h.dat';
file3 = 'iter_new_values.dat';
points_l = importdata([path,file1]);%��������
points_h = importdata([path,file2]) ;
values_l = tip_opt.Model.predict(points_l);
values_h = importdata([path,file3]);%��������ֵ



data_h = [points0_h,values0_h;points_h,values_h];
data_l = [points0_l,values0_l;points_l,values_l];

sam = Sample('mult','E3',0,0);
sam.put_in('all_h',data_h);
sam.put_in('all_l',data_l);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

[x,y]=opt.select_GEI('high');
x1=[];
mm = mean(opt.Sample.values_h);
%ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance()/opt.Model.GP{1}.getProcessVariance())+1);
ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance())+1);
threshold = opt.y_min*ww + mm*(1-ww);
for i=1:size(y,1)
    if y(i)<threshold
        x1=[x1;x(i,:)];
    end
end
x0=opt.cluster(x);
if size(x1,1)>1
    x2=opt.cluster(x1);
else
    x2=x1;
end
  