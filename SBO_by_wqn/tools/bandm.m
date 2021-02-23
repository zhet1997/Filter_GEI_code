clc;clear;
path1 = 'D:\Users\ASUS\Desktop\GE-E3第一级静叶中间截面验证20190716\mach\';
dirs = dir([path1,'*.dat']);
fileNames={dirs.name}';
load('D:\Users\ASUS\Desktop\GE-E3第一级静叶中间截面验证20190716\point.mat');
for i=1:4
   data{i,1} = importdata([path1,fileNames{i,1}]); 
end

c= linspecer(4) ;
k = [3 7 8 12 13];
% for ii=5:-1:1
%     i=k(ii);
%     plot(data{i,1}(1:101,1),data{i,1}(1:101,2),'Color',c(ii,:),'Linewidth',2); hold on;
% end
% for  ii=5:-1:1
%     i=k(ii);
%     plot(data{i,1}(102:202,1),data{i,1}(102:202,2),'Color',c(ii,:),'Linewidth',2);
% end


for i=1:4
     %i=k(ii);
 
plot(data{i,1}(:,1),data{i,1}(:,2),'Color',c(i,:),'Linewidth',2);hold on;
end
plot(mach(:,1)/3.385,mach(:,2),'ro');
xlabel('X/mm                                                            ');
 ylabel('Y/mm');
 legend('CFX-0.878','CFX-202190','MAP-0.878','MAP-202190')
%legend('参考设计','最优结果1','最优结果2','最优结果3','最优结果4','最优结果5','最优结果6',...
%'最优结果7','最优结果8','最优结果9','最优结果10','最优结果11','最优结果12');
set(gca,'FontSize',14);
%axis([-35 35 -10 60])
box off