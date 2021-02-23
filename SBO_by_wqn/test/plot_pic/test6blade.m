clc;clear;
baseline = [3.1;0.5;33.85;59.8;90;69;45;0.75;15.2;4.5;0.35;9;0.4;0.54;0.62;0.45;0.45;0.7];%pitch的参考叶型


%====================================================
for ii = 1:5
    for jj =1:5
    x = [0.15*(ii-1)+0.2,2*(jj-1)+3];
   %x = [2*(ii-1)+30,2*(jj-1)+3];
    bla = Blade_cut(change(baseline,[14,10],x));
    s = bla.draw3;
     draw(s,[ii*50+15,jj*50-25])
    end
end
axis equal 
axis([0 300 0 300])
%xlabel('轴向弦长');
xlabel('SLE2');
ylabel('出口偏转角/o');
%tt='叶型随参数变化示意图';
%title(tt);

set(gca,'Ytick',[50 100 150 200 250]);
set(gca,'YTickLabel',{'3','5','7','9','11'});

set(gca,'Xtick',[50 100 150 200 250]);
%set(gca,'XTickLabel',{'30','32','34','36','38'});
set(gca,'XTickLabel',{'0.2','0.35','0.5','0.65','0.8'});
%========================================================


% 
% 
% bla = Blade_cut([3.1;0.5;33.8;58.1;90;69;42;0.76;16.3;4.5;0.3;9;0.4;0.6;0.46;0.4;0.5;0.6]);
% %bla = Blade_cut([3.1;0.5;33.8;58.1;90;69;42;0.76;6.3;4.5;0.3;9;0.4;0.6;0.46;0.4;0.5;0.6]);
% close all;
% %figure(1);
% 
% %axis equal 
% %box off
% 
% figure(2);%
% 
% bla.draw2;
% hold on
% 
% axis equal 
% box off
% 
% 
% s = bla.draw3;
% draw(s,[50,0])

 function draw(data,move)
            viscircles(data{1,1}+move,data{2,1},'EdgeColor','b','LineWidth',0.5);hold on
            %画前缘圆形
            viscircles(data{1,2}+move, data{2,2},'EdgeColor','b','LineWidth',0.5);
            plot(data{1,3}+move(1),data{2,3}+move(2),'b-');
            plot(data{1,4}+move(1),data{2,4}+move(2),'b-');
            plot(data{1,5}+move(1),data{2,5}+move(2),'b-');
        
 end
  
 function design = change(baseline,para,x)
 design = baseline;
 design(para)=x;
 end