%用于绘制高低精度样本分布的图像
clc;clear;
sam = Sample('high','branin',100);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);


density = 50;

figure(1)
x1 = linspace( 0, 1, density );
x2 = linspace( 0, 1, density );
gridx = makeEvalGrid( {x1 x2} );
[gridy, grids2] = mod.predict( gridx );
% contour( x1, x2, reshape( gridy, density, density ),50 );
 
 
%  path = 'D:\Users\ASUS\Desktop\论文最终整理\';
%  sample = importdata([path,'samples.dat']);
sample = LHS(2,20);

s = 12;

 
%  plot(sample(:,1),sample(:,2),'ks','MarkerFaceColor','b','markersize',s,'MarkerEdgeColor','k');
%  ss = cluster(sample,mod.predict(sample),0,6);hold on
%  plot(ss(:,1),ss(:,2),'o','MarkerFaceColor','r','markersize',8,'MarkerEdgeColor','k');
%  
 
 plot(sample(:,1),sample(:,2),'ks','MarkerFaceColor','w','markersize',s,'MarkerEdgeColor','b');
 ss = cluster(sample,mod.predict(sample),0,10);hold on
 plot(ss(:,1),ss(:,2),'o','MarkerFaceColor','r','markersize',6,'MarkerEdgeColor','r');
 axis equal
 
 
%  set(gca,'Ytick',[]);
%  set(gca,'YTickLabel',{});
%  
%  set(gca,'Xtick',[]);
%  set(gca,'XTickLabel',{});
 
%hl = legend( 'source samples','target samples');
axis([0 1 0 1])
hl = legend( 'LF samples','HF samples');
set(gca,'FontSize',15);
xlabel('X')
ylabel('Y')
set(hl,'Orientation','horizon')
 
% figure(2)
% contour( x1, x2, reshape( gridy, density, density ),50 );hold on
% plot(sample(:,1),sample(:,2),'ks','MarkerFaceColor','b','markersize',s,'MarkerEdgeColor','k');
%  
%  ss = cluster(sample,mod.predict(sample),1,20);
%  plot(ss(:,1),ss(:,2),'o','MarkerFaceColor','r','markersize',s,'MarkerEdgeColor','k');
%  axis equal
%  
%  
%  set(gca,'Ytick',[]);
%  set(gca,'YTickLabel',{});
%  
%  set(gca,'Xtick',[]);
%  set(gca,'XTickLabel',{});
%  
 
 function [y] = cluster(points_l,values_l,addtype,number)

points_h = points_l;
values_h = values_l;

for i=1:20-number
    
    %==================================================
    y = pdist(points_h,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%两个最接近的样本点之一
    p2 = z(1,2);%两个最接近的样本点之一
    d1 = sum((points_h(p1,:) - linspace(0.5,0.5,2)).^2);
    d2 = sum((points_h(p2,:) - linspace(0.5,0.5,2)).^2);
  switch addtype 
      case {1,0}
     if d1<d2%选择距离中心远的那一个去除
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

 function [y] = LHS(dim,num)
%构造优化LHS样本集
ad=3;
points = lhsdesign(num*ad, dim);%输出为n*m的矩阵
for i=1:num*(ad-1)
    y = pdist(points,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%两个最接近的样本点之一
    p2 = z(1,2);%两个最接近的样本点之一
%     d1 = sum((points(p1,:) - linspace(0.5,0.5,dim)).^2);
%     d2 = sum((points(p2,:) - linspace(0.5,0.5,dim)).^2);
    
%     if d1<d2%选择距离中心远的那一个去除
%         points(p2,:) = [];
%     else
%         points(p1,:) = [];
%     end

    if rand(1)<0.5
        points(p2,:) = [];
    else
        points(p1,:) = [];
    end



end
y = points;%输出为描述样本分布的矩阵
end
 