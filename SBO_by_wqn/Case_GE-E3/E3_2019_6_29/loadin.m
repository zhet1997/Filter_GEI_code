clc;clear;
load('D:\Users\ASUS\Desktop\迁移学习算例20190701\blade.mat');
% plot(ref(1:101,1),ref(1:101,2),'k-','linewidth',1.5);
% hold on
% plot(opt1(1:101,1),opt1(1:101,2),'r','linewidth',2);
% plot(opt2(1:101,1),opt2(1:101,2),'b','linewidth',2);
% 
% 
% 
%  plot(ref(102:202,1),ref(102:202,2),'k-','linewidth',1.5);
%  plot(opt1(102:202,1),opt1(102:202,2),'r','linewidth',2);
%  plot(opt2(102:202,1),opt2(102:202,2),'b','linewidth',2);
c= linspecer(8) ;
for i=8:-1:1
    plot(all_blade(1:101,1,i),all_blade(1:101,2,i),'Color',c(i,:),'Linewidth',2); hold on;
end
for  i=8:-1:1
    plot(all_blade(102:202,1,i),all_blade(102:202,2,i),'Color',c(i,:),'Linewidth',2);
end
  xlabel('X/mm                                                            ');
 ylabel('Y/mm');
legend('参考设计','最优结果1','最优结果2','最优结果3','最优结果4','最优结果5','最优结果6',...
'最优结果7');%,'最优结果8','最优结果9','最优结果10','最优结果11','最优结果12');
set(gca,'FontSize',14);
axis([-35 35 -10 60])
box off