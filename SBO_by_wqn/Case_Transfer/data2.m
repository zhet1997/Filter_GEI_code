%2019-7-19
%�����ļ���ȡ
%������������Ż������ҶƬ�����ߵ�
clc;clear;
%path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190707\result\';
path = 'D:\study\���Ȼ���\Ǩ��ѧϰ����20190707\result\';

hold off
for lowfunc = 0.7
    a=zeros(4,3,5);
    ii=1;
for number = [5,10,20,30,40]
    s=[];
for addtype = [0,1,2,3]
    box = zeros(10,5);
    box2 = zeros(10,3);
for time = 1:10
    if addtype==0
        low=0;
    else
        low=lowfunc;
    end
   load([path,num2str(low),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'])
   m = min(opt.Sample.values_h(1:number,:));%��ʼ�ӵ����Сֵ
   ss = opt.best_location;
   box2(time,:)=ss;
   box(time,1)=m;
   box(time,2:5)=opt.value_min_record([5,10,15,20]);
end
    s = [s;sum(box2,1)/10];
end

s(:,1) = 30 +8*s(:,1);
s(:,2) = 3 +8*s(:,2);
s(:,3) = 0.2 +0.6*s(:,3);
      
      
    a(:,:,ii) = s;
    ii=ii+1;
end
end


%====================================================
baseline = [3.1;0.5;33.85;59.8;90;69;45;0.75;15.2;4.5;0.35;9;0.4;0.54;0.62;0.45;0.45;0.7];%pitch�Ĳο�Ҷ��
c = linspecer(4);c=[c;0,0,0];
for ii = 5%[1,2,4,5]
    for jj =1%[1 2 3 4]
        if ii ==5
            bla = Blade_cut(baseline);
        else
    x = a(ii,:,jj);
   %x = [2*(ii-1)+30,2*(jj-1)+3];
    bla = Blade_cut(change(baseline,[3,10,14],x));
        end
    s = bla.draw3;hold on
     draw(s,[jj*50-25,0],c(ii,:));
    end
end
axis equal 

 axis([-20 50 -10 60])
% %xlabel('�����ҳ�');
% xlabel('SLE2');
% ylabel('����ƫת��/o');
% %tt='Ҷ��������仯ʾ��ͼ';
% %title(tt);
% 
% set(gca,'Ytick',[50 100 150 200 250]);
% set(gca,'YTickLabel',{'3','5','7','9','11'});
% 
% set(gca,'Xtick',[50 100 150 200 250]);
% %set(gca,'XTickLabel',{'30','32','34','36','38'});
% set(gca,'XTickLabel',{'0.2','0.35','0.5','0.65','0.8'});
%========================================================

%c=['k','r','b','g'];
% c = linspecer(4);
% l={'-',':','--','-','-'};
% m = {'o','o','+','*','^'};
% for j=[2,3,5]
% for i=1:4
% plot(1:5,reshape(a(i,j,:),1,5),l{1,j},'color',c(i,:),'Linewidth',2);hold on
% end
% end
% 
% for j=[2,3,5]
% for i=1:4
% plot(1:5,reshape(a(i,j,:),1,5),m{1,j},'color',c(i,:),'markersize',10);
% end
%end


%axis([0.9 5.1 0.0351 0.036])
% axis([0.9 5.1 0.0351 0.037])
% 
% l = legend('��Ǩ��-5�ε������','�ӵ㷽ʽ1-5�ε������','�ӵ㷽ʽ2-5�ε������','�ӵ㷽ʽ3-5�ε������',...
% '��Ǩ��-10�ε������','�ӵ㷽ʽ1-10�ε������','�ӵ㷽ʽ2-10�ε������','�ӵ㷽ʽ3-10�ε������',...
% '��Ǩ��-10�ε������','�ӵ㷽ʽ1-10�ε������','�ӵ㷽ʽ2-10�ε������','�ӵ㷽ʽ3-10�ε������');
% set(l,'FontSize',10)
% set(l, 'Box', 'off');
% xlabel('��ʼĿ������������');
% ylabel('��������ֵ');
% tt='���������Ϊ0.9��ΪǨ����Դ';
% title(tt);
% 
% set(gca,'Xtick',[1 2 3 4 5]);
% set(gca,'XTickLabel',{'5','10','20','30','40'});

%===============================================================================================================

 function draw(data,move,col)
            viscircles(data{1,1}+move,data{2,1},'EdgeColor',col,'LineWidth',0.5);hold on
            %��ǰԵԲ��
            viscircles(data{1,2}+move, data{2,2},'EdgeColor',col,'LineWidth',0.5);
            plot(data{1,3}+move(1),data{2,3}+move(2),'color',col);
            plot(data{1,4}+move(1),data{2,4}+move(2),'color',col);
            plot(data{1,5}+move(1),data{2,5}+move(2),'color',col);
        
 end
  
 function design = change(baseline,para,x)
 design = baseline;
 design(para)=x;
 end















