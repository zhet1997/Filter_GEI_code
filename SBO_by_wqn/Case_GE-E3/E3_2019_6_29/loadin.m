clc;clear;
load('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190701\blade.mat');
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
legend('�ο����','���Ž��1','���Ž��2','���Ž��3','���Ž��4','���Ž��5','���Ž��6',...
'���Ž��7');%,'���Ž��8','���Ž��9','���Ž��10','���Ž��11','���Ž��12');
set(gca,'FontSize',14);
axis([-35 35 -10 60])
box off