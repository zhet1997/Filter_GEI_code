clc;clear;
% xx=linspace(0.3,0.6,100);
% yy=linspace(0.3,0.6,100);
% zz=zeros(100,100)+0.3;
% [x,y]=meshgrid(xx,yy);
% surf(x,y,zz);
% axis([0 1 0 1 0 1]);
% hold on
% xx=linspace(0.4,0.7,100);
% yy=linspace(0.2,0.5,100);
% zz=zeros(100,100)+0.8;
% [x,y]=meshgrid(xx,yy);
% surf(x,y,zz);
%load('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190706\result30.mat');
load('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190702\result.mat');
load('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190702\ini.mat');

for j=1:12
y_box(1,j)=ini_min(j);
f_min = ini_min(j);
for i=1:30
f_min = min(f_min,x_box(i,8,j));
y_box(i+1,j) = f_min;
end
end
kk=9;hold off;
% 1.Kriging����EI����45��ʼ��������С����ɾȥ���е���ģ� %��ɫ
% 2.Cokriging����EI����210��tip�������롪��45��ʼ��������С����ɾȥ���е���ģ�        p    ��ɫ
% 3.Cokriging����EI����210��tip�������롪��45��ʼ��������С����ɾȥ��tipֵ��ģ�       v    ��ɫ
% 4.Cokriging����EI����210��tip�������롪��45��ʼ��������210��tip������ֱ��ѡ��С�ģ�  m    ��ɫ
plot(0:30,[y_box(:,kk)+0.00001],'k-','LineWidth',2);hold on
plot(0:30,y_box(:,kk+1),'r-','LineWidth',2);
plot(0:30,y_box(:,kk+2),'b-','LineWidth',2);
plot(0:30,y_box(:,kk+3)-0.00001,'g-','LineWidth',2);
%==========================================
plot(0:30,y_box(:,kk)+0.00001,'ko');
plot(0:30,y_box(:,kk+1),'ro');
plot(0:30,y_box(:,kk+2),'bo');
plot(0:30,y_box(:,kk+3)-0.00001,'go');

l = legend('��Ǩ��','�ӵ㷽ʽ1','�ӵ㷽ʽ2','�ӵ㷽ʽ3');
set(l, 'Box', 'off');
axis([-0.5 30.5 0.0315 0.0330]);
xlabel('��������');
ylabel('��������ֵ');
tt='pitch-105-��ʼ�ӵ�';
%title(tt);
box off

%path ='D:\Users\ASUS\Desktop\��������20190709\pic\';
%saveas(1,[path,tt,'.png']);

% f = getframe(gcf);
% imwrite(f.cdata, [path,tt,'.png']);

z_box=zeros(12,7);
for i = 1:12

p=find(x_box(:,8,i)==min(x_box(:,8,i)));
p=p(1);
z_box(i,:)=x_box(p,1:7,i);
end