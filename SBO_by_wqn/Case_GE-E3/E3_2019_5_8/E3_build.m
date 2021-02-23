clc;clear;
path = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\响应面数据提取\';
file0 = 'points_150.dat';
% file1 = '0.6_pitch_ini_values_210.dat';
% file2 = '0.7_pitch_ini_values_210.dat';
% file3 = '0.8_pitch_ini_values_210.dat';
% file4 = '0.9_pitch_ini_values_210.dat';
% file5 = '1.0_pitch_ini_values_210.dat';
% file6 = '1.1_pitch_ini_values_210.dat';

file1 = 'result0.6.dat';
file2 = 'result0.7.dat';
file3 = 'result0.8.dat';
file4 = 'result0.9.dat';
file5 = 'result1.0.dat';
file6 = 'result1.1.dat';

%data = importdata([path,file0]);
val_1 = importdata([path,file1]);
val_2 = importdata([path,file2]);
val_3 = importdata([path,file3]);
val_4 = importdata([path,file4]);
val_5 = importdata([path,file5]);
val_6 = importdata([path,file6]);


data = [val_1,val_2,val_3,val_4,val_5,val_6];

%   sam1 = Sample('high','E3',0);
%   sam1.put_in('all_h',[data,val_t]);
%   mod1 = oodacefit( sam1.points, sam1.values, struct());
%   opt1 = Iteration(sam1,mod1);
%   
%   
%   sam2 = Sample('high','E3',0);
%   sam2.put_in('all_h',[data,val_h]);
%   mod2 = oodacefit( sam2.points, sam2.values, struct());
%   opt2 = Iteration(sam2,mod2);
%   
%   
%   density=0.2;
%   for i=1:7
%       eval(['x',num2str(i),'=0:',num2str(density),':1;']);
%       eval(['xx{1,',num2str(i),'}=x',num2str(i),';']);
%   end
%   gridx = makeEvalGrid(xx);
%   gridy1 = zeros(size(gridx,1),1);%原模型序列
%   gridy2 = zeros(size(gridx,1),1);%代理模型序列
%   for i=1:size(gridx,1)
%       
%        gridy1(i) =opt1.Model.predict( gridx(i,:));
%        gridy2(i) =opt2.Model.predict( gridx(i,:));
% %        gridy1(i) =Testmodel( gridx(i,:),'ackley');
% %        gridy2(i) =Errormodel( gridx(i,:),6);
% 
% 
%       
%   end
  % mean=sum(gridy1)/(density^dimension);
  % mse=sqrt(sum((gridy1-mean).^2)/(density^dimension));
  
  %corr1 = corr(gridy1,gridy2,'type' , 'pearson');
  %corr2 = corr(gridy1,gridy2,'type' , 'Spearman');
  
  %corr1 = corr(val_t,val_h,'type' , 'pearson');
  %corr2 = corr(val_t,val_h,'type' , 'Spearman');
  

mat1 = zeros(6,6);
mat2 = zeros(6,6);
mat3 = zeros(6,6);

for i = 1:6
    for j = 1:i
  %eval(["corr1 = corr(dat",num2str(i),",dat",num2str(j),",'type' , 'pearson');"]);
  corr1 = corr(data(:,i),data(:,j),'type' , 'pearson');
  corr2 = corr(data(:,i),data(:,j),'type' , 'Spearman');
  corr3 = corr(data(:,i),data(:,j),'type' , 'Kendall');
  
  mat1(i,j) = corr1;
  mat2(i,j) = corr2;
  mat3(i,j) = corr3;
  
  
  
    end
end
  
  
    %corr3 = corr(gridy1,gridy2,'type' , 'Kendall');
  
  %输出结果
  %fprintf("该响应面的Pearson系数是%s\n",corr1);
  %fprintf("该响应面的Spearman系数是%s\n",corr2);
  %fprintf("该响应面的Kendall系数是%s\n",corr3);