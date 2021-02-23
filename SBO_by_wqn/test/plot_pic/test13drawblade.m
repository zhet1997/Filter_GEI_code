clc;clear;
path = 'D:\Users\ASUS\Desktop\post\';
file1 = '3.81.dat';
file2 = '3.42.dat';
file3 = 'Sec_1.dat';
file4 = 'Sec_1_Fit.dat';
dat1 = importdata([path,file1]);
dat2 = importdata([path,file2]);
dat3 = importdata([path,file3]);
dat4 = importdata([path,file4]);
plot(dat1(1:101,1),dat1(1:101,2),'k-','linewidth',1.5);
hold on
%plot(dat2(1:101,1),dat2(1:101,2),'r','linewidth',2);
%plot(dat3(1:101,1),dat3(1:101,2),'b','linewidth',2);

 plot(dat1(102:202,1),dat1(102:202,2),'k-','linewidth',1.5);
 %plot(dat2(102:202,1),dat2(102:202,2),'r','linewidth',2);
 %plot(dat3(102:202,1),dat3(102:202,2),'b','linewidth',2);
% 


 xlabel('X/mm                                                            ');
 ylabel('Y/mm');
legend('参考设计','Filter-GEI优化设计','EI优化设计');
set(gca,'FontSize',14);
axis([-35 35 -10 60])
box off