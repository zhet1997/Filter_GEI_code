%2019-7-19
%计算各响应面精度
%==========================================================================
clc;clear;
%读取与储存路径
path1 = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\surf\';
path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\';
path3 = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\result\';
%参数选择
box =[];
for lowfunc = [0.7,0.8,0.9,1.0,1.1]

    
inform.lowfunc=lowfunc;


%加载高低精度响应面mat文件
load([path1,'res_surf',num2str(0.6),'.mat'],'mod');
fun_h = mod;
load([path1,'res_surf',num2str(lowfunc),'.mat'],'mod');

fun_l = mod;
clear('mod');


%开始计算响应面精度
density=0.05;
for i=1:3
    eval(['x',num2str(i),'=0:',num2str(density),':1;']);
    eval(['xx{1,',num2str(i),'}=x',num2str(i),';']);
end
gridx = makeEvalGrid(xx);
gridy1 = fun_h.predict(gridx);%原模型序列
gridy2 = fun_l.predict(gridx);%代理模型序列


%计算相关系数
corr1 = corr(gridy1,gridy2,'type' , 'pearson');
corr2 = corr(gridy1,gridy2,'type' , 'Spearman');

%计算均方根误差
temp = gridy1-gridy2;
temp = temp'*temp;
mse = sqrt(temp/size(gridx,1));

    
box = [box;lowfunc,corr1,corr2,mse];   
end






