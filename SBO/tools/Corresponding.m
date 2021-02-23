clc;clear;
path = 'D:\Users\ASUS\Desktop\�Ż�����2019_6_14\�������\result\';
file0 = 'points.dat';
file1 = 'eloss1.dat';
file2 = 'eloss2.dat';
file3 = 'eloss3.dat';
file4 = 'eloss4.dat';
file5 = 'eloss5.dat';
dat0 = importdata([path,file0]);
dat1 = importdata([path,file1]);
dat2 = importdata([path,file2]);
dat3 = importdata([path,file3]);
dat4 = importdata([path,file4]);
dat5 = importdata([path,file5]);

data = [dat1,dat2,dat3,dat4,dat5];

mat1 = zeros(5,5);
mat2 = zeros(5,5);
mat3 = zeros(5,5);

for i = 1:5
    for j = 1:5  
  %eval(["corr1 = corr(dat",num2str(i),",dat",num2str(j),",'type' , 'pearson');"]);
  corr1 = corr(data(:,i),data(:,j),'type' , 'pearson');
  corr2 = corr(data(:,i),data(:,j),'type' , 'Spearman');
  corr3 = corr(data(:,i),data(:,j),'type' , 'Kendall');
  
  mat1(i,j) = corr1;
  mat2(i,j) = corr2;
  mat3(i,j) = corr3;
  
  
  
    end
end
  
  %������
%   fprintf("����Ӧ���Pearsonϵ����%s\n",corr1);
%   fprintf("����Ӧ���Spearmanϵ����%s\n",corr2);
  %fprintf("����Ӧ���Kendallϵ����%s\n",corr3);