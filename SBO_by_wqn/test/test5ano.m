 clc;clear;
%加载

% path = 'D:\Users\ASUS\Desktop\优化算例2019_6_14\结果分析\result\';
% file0 = 'points.dat';
% file1 = 'eloss1.dat';
% file2 = 'eloss2.dat';
% file3 = 'eloss3.dat';
% file4 = 'eloss4.dat';
% file5 = 'eloss5.dat';
% dat0 = importdata([path,file0]);
% dat1 = importdata([path,file1]);
% dat2 = importdata([path,file2]);
% dat3 = importdata([path,file3]);
% dat4 = importdata([path,file4]);
% dat5 = importdata([path,file5]);

%path = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\source\';
%path = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\响应面数据提取\';
path = 'D:\study\已完成具体事项\工热会议\迁移学习算例20190707\响应面数据提取\';
%path = 'D:\Users\ASUS\Desktop\迁移学习算例20190707\anova\';
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


dat0 = importdata([path,file0]);
dat1 = importdata([path,file1]);
dat2 = importdata([path,file2]);
dat3 = importdata([path,file3]);
dat4 = importdata([path,file4]);
dat5 = importdata([path,file5]);
dat6 = importdata([path,file6]);
DAT = [dat1,dat2,dat3,dat4,dat5,dat6];

sss=[];
for num = [105 90 75 60 45 30 15 5]


for jj =1:6
if jj==1
[x,y] = cluster(dat0,DAT(:,jj),num);
else
[x,y] = cluster(dat0,DAT(:,jj),105);
end
    
sam = Sample('high','E3',0);
sam.put_in('all_h',[x,y]);
%sam.put_in('all_h',[dat0,dat1]);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

    %======================================================
 %sam = Sample('mult','branin',30,20);
%  sam = Sample('high','branin',200);
%   mod = oodacefit( sam.points, sam.values, struct());
%   opt = Iteration(sam,mod);
  %=======================================================
  %ano = Cokriging_ANOVA(opt.Sample,opt.Model);
 ano = ANOVA_k(opt.Sample,opt.Model); 
    
 xx=0:0.005:1;
 y=zeros(ano.dimension,size(xx,2));
 
 xc = ones(ano.dimension*2,size(xx,2));
 for ii = 1:ano.dimension
 xc(2*ii-1,:)=xc(2*ii-1,:)*ii;
 end
 for ii = 1:ano.dimension
 xc(2*ii,:)=xx;
 end
 xcc = mat2cell(xc,linspace(2,2,ano.dimension),linspace(1,1,size(xx,2)));
 
 ya =cellfun(@ano.get_miu,xcc);
 
%  for jj=1:ano.dimension
%      for ii = 1:size(xx,2)
%          y(jj,ii) = ano.get_miu(jj,xx(ii));
%      end
%  end

 figure(1);
 for ii=1:ano.dimension
     plot(xx,ya(ii,:),'LineWidth',2);
     hold on
 end
 %legend('前缘半径','圆心连线角','进口上楔角','前缘修正','出口偏转角','关联系数','出口楔角','SLE1','SLE2','STE1','STE2');
%legend('前缘半径','圆心连线角','进口上楔角','有效出气角','出口偏转角','关联系数','SLE1','SLE2');
% hl = legend('轴向弦长','出口偏转角','SLE2');
% set(hl,'box','off')



yy = ya-ano.get_miu([]);
yy = yy.*yy;
s = sum(yy,2);
%figure(2);
%pie(s/sum(s));
%legend('前缘半径','圆心连线角','进口上楔角','前缘修正','出口偏转角','关联系数','出口楔角','SLE1','SLE2','STE1','STE2');
%legend('前缘半径','圆心连线角','进口上楔角','有效出气角','出口偏转角','关联系数','SLE1','SLE2');
%label = {'前缘半径','圆心连线角','进口上楔角','前缘修正','出口偏转角','关联系数','出口楔角','SLE1','SLE2','STE1','STE2'};
%hl = legend('轴向弦长','出口偏转角','SLE2');
%set(hl,'box','off')

%box = [opt.y_min, opt.y_min_res, opt.y_min_co]; 
box{1,jj} = ya;
box{2,jj} = ano.get_miu([]);
end
  


for i=1:6
a{1,i} = (box{1,i}-box{2,i})*100;
end


for i = 1:6
    temp = a{1,i};
    temp = temp.*temp;
    s1(i,:)=sum(temp,2);
end

ss1 = sqrt(ones(6,3)./s1);

for i=1:6
    temp = a{1,1}-a{1,i};
    temp = temp.*temp;
    s2(i,:) = sum(temp,2);
end
s2 =s2./s1;

for i=1:6
    
    temp = ss1(1,:)'.*a{1,1}-ss1(i,:)'.*a{1,i};
    temp = temp.*temp;
    s3(i,:) = sum(temp,2);
end

s3=s3.*s1./[sum(s1,2),sum(s1,2),sum(s1,2)];
 sss = [sss,sum(s3,2)];

% path1 ='D:\Users\ASUS\Desktop\迁移学习算例20190707\';
% save([path1,'surf\res_surf1.1.mat'],'mod');
% path ='D:\Users\ASUS\Desktop\迁移学习算例20190707\pic3\';saveas(1,[path,file6,'_line.png']);
% path ='D:\Users\ASUS\Desktop\迁移学习算例20190707\pic3\';saveas(2,[path,file6,'_pie.png']);
% filename = 'surf.dat';
% wdat([importdata([path1,filename]);box],[path1,filename])%这是整个写入，而非在后面加上   
end

function [x,y] = cluster(points_l,values_l,number)

points_h = points_l;
values_h = values_l;

for i=1:150-number
    
    %==================================================
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
    



    values_h(p,:)=[];
    points_h(p,:) = [];%去除第p个点


end
x= points_h;
y = values_h;
end
    
    