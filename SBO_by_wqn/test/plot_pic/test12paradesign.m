baseline = [3.1;0.5;33.85;59.8;90;69;45;0.75;15.2;4.5;0.35;9;0.4;0.54;0.62;0.45;0.45;0.7];%pitch的参考叶型
%baseline = [3.1;0.5;33.85;59.8;90;69;45;0.75;15.2;4.5;0.35;9;0.4;0.54;0.62;0.45;0.45;0.7];%pitch的参考叶型
c = linspecer(4);
c=[c;0,0,0];

%=======================================================
% % bla = Blade_cut(baseline);
% bla = Blade_cut(change(baseline,[3,10,14],[34,7,0.5]));
% %bla.draw1;hold on
% bla.draw4;hold on
% s = bla.draw3;hold on
% %draw(s,[0,0],c(ii,:));
% draw(s,[0,44.5],'k');
% axis equal
% axis([-40 80 -50 110])
% box off
% %axis off
% text(-37,54,'A');
% text(-33,63,'B');
% text(-25,75,'C');
% text(-17,58,'D');
% text(-10,40,'E');
%=========================================================
 
 %================================================================================================
 range = [8,16,0.6];
 diff =zeros(9,3);
 aa = [1,0,-1];
 bb = [1,1,1,0,0,0,-1,-1,-1];
 cc = {'r','k','b','r','k','b','r','k','b'};
 for ii=1:3
     for jj=1:3
    diff(3*ii-jj+1,ii)=range(ii)*0.25*aa(jj);
     end
 end
 
 for ii=1:9
  bla = Blade_cut(change(baseline,[3,10,14],[34,7,0.5]+diff(ii,:)));
    s = bla.draw3;hold on
   %draw0(s,[60,44.5*bb(ii)],cc{1,ii});
   draw0(s,[0,40*bb(ii)],cc{1,ii});
 end
 axis equal 
 %=====================================
 
%  h(1)= plot([0,0],[0,0],'color','b','LineWidth',1);
%  h(2)= plot([0,0],[0,0],'color','r','LineWidth',1);
%  h(3)= plot([0,0],[0,0],'color','k','LineWidth',1);
%  h(4)= plot([0,0],[0,0],'color','r','LineWidth',1);
%  h(5)= plot([0,0],[0,0],'color','b','LineWidth',1);
%  h(6)= plot([0,0],[0,0],'color','g','LineWidth',1);
 %[legh,objh,outh,outm]=legend([h(1),h(3),h(2)],'x_i+0.25\Delta x_i','x_i','x_1-0.25\Delta x_i');

% [legh2,objh2]=legend([h(4),h(5),h(6)],'Bezier curve 1','Bezier curve 2','Bezier curve 3');





 function draw(data,move,col)
            
            plot(data{1,3}+move(1),data{2,3}+move(2),'color','r','LineWidth',1.5);
            plot(data{1,4}+move(1),data{2,4}+move(2),'color','b','LineWidth',1.5);
            plot(data{1,5}+move(1),data{2,5}+move(2),'color','g','LineWidth',1.5);
            viscircles(data{1,1}+move,data{2,1},'EdgeColor',col,'LineWidth',1);hold on
            %画前缘圆形
            viscircles(data{1,2}+move, data{2,2},'EdgeColor',col,'LineWidth',1);
        
 end
 
 function draw0(data,move,col)
            
            plot(data{1,3}+move(1),data{2,3}+move(2),'color',col,'LineWidth',1);
            plot(data{1,4}+move(1),data{2,4}+move(2),'color',col,'LineWidth',1);
            plot(data{1,5}+move(1),data{2,5}+move(2),'color',col,'LineWidth',1);
            viscircles(data{1,1}+move,data{2,1},'EdgeColor',col,'LineWidth',1);hold on
            %画前缘圆形
            viscircles(data{1,2}+move, data{2,2},'EdgeColor',col,'LineWidth',1);
        
 end
  
 function design = change(baseline,para,x)
 design = baseline;
 design(para)=x;
 end




