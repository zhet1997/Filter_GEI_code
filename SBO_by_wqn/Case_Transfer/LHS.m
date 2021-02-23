clc;clear;
num=5;
ad=2;


%for j=1:10
    
    points_l=lhsdesign(num*ad, 3);%输出为n*m的矩阵
    points_h = points_l;
    for i=1:num*(ad-1)
        y = pdist(points_h,'euclid');
        z = linkage(y,'single');
        p1 = z(1,1);%两个最接近的样本点之一
        p2 = z(1,2);%两个最接近的样本点之一
        d1 = sum((points_h(p1,:) - linspace(0.5,0.5,3)).^2);
        d2 = sum((points_h(p2,:) - linspace(0.5,0.5,3)).^2);
        
        if d1>d2%选择距离中心近的那一个去除
            p = p2;
        else
            p = p1;
        end
        
        points_h(p,:) = [];%去除第p个点
        
    end
    
   % ini_sample_box{1,j} = points_l;
%end


%save('D:\Users\ASUS\Desktop\迁移学习算例20191025\sample30.mat','ini_sample_box')