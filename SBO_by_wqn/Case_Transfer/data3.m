%2019-7-19
%�����ļ���ȡ
clc;clear;
%path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190707\';
path = 'D:\study\���Ȼ���\Ǩ��ѧϰ����20190707\';

box = importdata([path,'relate.dat']);

a = reshape(box(:,6),10,4,5,5);
b = reshape(sum(a,1),4,5,5)/10;

hold off
%c=['k','r','b','g'];
c = linspecer(3);
l={'-',':','-','-.','-'};
m = {'^','ks','o','*','+'};
% for j=[5]
% for i=1:4
% plot(1:5,reshape(b(i,:,j),1,5),l{1,j},'color',c(i,:),'Linewidth',2);hold on
% plot(1:5,reshape(b(i,:,j),1,5),m{1,j},'color',c(i,:),'markersize',10);
% end
% end

for j=[3]
for k =1:10
    f= [1 2 4];
for ii=1:3
    i=f(ii);
plot((1:5)+0.2*ii-0.5,reshape(a(k,i,:,j),1,5),m{1,j},'color',c(ii,:),'markersize',10);hold on
end
end
end

%axis([0.5 5.5 0 0.01])

axis([0.5 5.5 0.7 1])
l = legend('��Ǩ��','�ӵ㷽ʽ1','�ӵ㷽ʽ2','�ӵ㷽ʽ3');
set(l,'FontSize',10)
set(l, 'Box', 'off');
xlabel('��ʼĿ������������');
ylabel('Spearman');
%ylabel('RSME');
tt='���������Ϊ0.9��ΪǨ����Դ';
title(tt);

set(gca,'Xtick',[1 2 3 4 5]);
set(gca,'XTickLabel',{'5','10','20','30','40'});