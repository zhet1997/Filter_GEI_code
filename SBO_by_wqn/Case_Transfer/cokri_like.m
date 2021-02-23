%2019-7-18
%研究一下高低精度模型相似性和样本数对Cokriging代理模型精度的影响
%用GE-E3第一级静叶中间截面在不同出口马赫数下的能量损失系数响应面来作为测试函数

%总是以0.6响应面作为高精度响应面
%分别以其他五个响应面作为低精度响应面

%低精度初始加点总是为50，加点方式为LHS
%提前准备10组LHS数据备用
%高精度初始加点数为 5 10 20 30 40，加点方式有四种

%对每种初始加点状态计算代理模型响应面精度
%==========================================================================
clc;clear;
%读取与储存路径
path1 = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\surf\';
path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\';
path3 = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\result\';
%参数选择

for lowfunc = [0.7,0.8,0.9,1.0,1.1] 
for number = [5,10,20,30,40]
for addtype = [0,1,2,3]
for time = 1:10
    
inform.lowfunc=0;
inform.number=number;
inform.addtype=addtype;
inform.time = time;

%加载高低精度响应面mat文件
load([path1,'res_surf',num2str(0.6),'.mat'],'mod');
fun_h = mod;
load([path1,'res_surf',num2str(lowfunc),'.mat'],'mod');
fun_l = mod;
clear('mod');
%加载LHS分布文件
load([path2,'sample.mat']);
%低精度采样
points_l = ini_sample_box{1,time};
values_l = fun_l.predict(points_l);
%选择高精度采样方式进行高精度采样
points_h = cluster(points_l,values_l,addtype,number);
values_h = fun_h.predict(points_h);
%建立初始响应面，计算初始响应面精度
%储存结果
if addtype==0
sam = Sample('high','E3',0);
sam.put_in('all_h',[points_h,values_h]);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);
else
sam = Sample('mult','E3',0,0);
sam.put_in('all_h',[points_h,values_h]);
sam.put_in('all_l',[points_l,values_l]);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);   
end
%开始计算响应面精度
density=0.05;
for i=1:3
    eval(['x',num2str(i),'=0:',num2str(density),':1;']);
    eval(['xx{1,',num2str(i),'}=x',num2str(i),';']);
end
gridx = makeEvalGrid(xx);
gridy1 = fun_h.predict(gridx);%原模型序列
gridy2 = opt.Model.predict(gridx);%代理模型序列


%计算相关系数
corr1 = corr(gridy1,gridy2,'type' , 'pearson');
corr2 = corr(gridy1,gridy2,'type' , 'Spearman');

%计算均方根误差
temp = gridy1-gridy2;
temp = temp'*temp;
mse = sqrt(temp/size(gridx,1));

    
box = [lowfunc,number,addtype,time,corr1,corr2,mse];    
%储存结果
%save([path3,num2str(inform.lowfunc),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'],'opt','inform')
filename = 'relate.dat';
wdat([importdata([path2,filename]);box],[path2,filename])%这是整个写入，而非在后面加上

end
end
end
end







function [y] = cluster(points_l,values_l,addtype,number)

points_h = points_l;
values_h = values_l;

for i=1:50-number
    
    %==================================================
    y = pdist(points_h,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%两个最接近的样本点之一
    p2 = z(1,2);%两个最接近的样本点之一
    d1 = sum((points_h(p1,:) - linspace(0.5,0.5,3)).^2);
    d2 = sum((points_h(p2,:) - linspace(0.5,0.5,3)).^2);
  switch addtype 
      case {1,0}
     if d1>d2%选择距离中心近的那一个去除
         p = p2;
     else
         p = p1;
     end
    
      case 2

    if values_h(p1)<= values_h(p2)%选择tip值大的那一个去除
        p = p2;
    else
        p = p1;
    end
     
    %====================================================
      case 3
    p=find(values_h==max(values_h));%找到最大的一个
    p=p(1);%可能有多个，只保留一个
    
  end

    values_h(p,:)=[];
    points_h(p,:) = [];%去除第p个点
end

y = points_h; 
end