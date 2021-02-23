clc;clear;hold off
load('D:\study\工热会议\迁移学习算例20190707\ano.mat','box')
%=======================================================
% xx=0:0.005:1;
% 
% figure(1);hold off
%  for ii=1:3
%      plot(xx,box{1,6}(ii,:),'LineWidth',2);
%      hold on
%  end
%  %legend('前缘半径','圆心连线角','进口上楔角','前缘修正','出口偏转角','关联系数','出口楔角','SLE1','SLE2','STE1','STE2');
% %legend('前缘半径','圆心连线角','进口上楔角','有效出气角','出口偏转角','关联系数','SLE1','SLE2');
% hl = legend('轴向弦长','出口偏转角','SLE2');
% set(hl,'box','off')





%=====================================================

bo = box;
clear('box');



for i=1:6
a{1,i} = (bo{1,i}-bo{2,i})*100;
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
b=a;
for i=1:6
    b{1,i}=ss1(i,:)'.*a{1,i};
end
c = linspecer(3);
 %l={'-','--','--','--','-','-'};


for i=1:3
 fill([1:201,201:-1:1]/201,[b{1,1}(i,:),b{1,3}(i,201:-1:1)],c(i,:));hold on
end

% for j =[3]
% for i=1:3
% plot([1:201]/201,b{1,j}(i,:),'-','color',c(i,:),'Linewidth',2);hold on
% end
% end
%axis([0 1 -0.2 0.5]);

l=legend('length of axial chord','outlet deflect angle','control point coefficient');
set(l,'FontSize',12)
set(l, 'Box', 'off');
s3=s3.*s1./[sum(s1,2),sum(s1,2),sum(s1,2)];