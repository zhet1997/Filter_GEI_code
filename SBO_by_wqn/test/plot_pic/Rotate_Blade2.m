clc;clear;
baseline = [3.1;0.5;33.85;59.8;90;69;45;0.75;15.2;4.5;0.35;9;0.4;0.54;0.62;0.45;0.45;0.7];%pitch的参考叶型


%====================================================

    bla = Blade_cut(baseline);
    s = bla.draw3;
    delta = s{1,2};
    angle = abs(atan(delta(2)/delta(1)));
   b =  rotate(s,-angle);
   draw(s,[0,0])
     draw(b,[0,0])




 function draw(data,move)
            viscircles(data{1,1}+move,data{2,1},'EdgeColor','k','LineWidth',0.5);hold on
            %画前缘圆形
            viscircles(data{1,2}+move, data{2,2},'EdgeColor','k','LineWidth',0.5);
            plot(data{1,3}+move(1),data{2,3}+move(2),'r-');
            plot(data{1,4}+move(1),data{2,4}+move(2),'r-');
            plot(data{1,5}+move(1),data{2,5}+move(2),'b-');
        axis equal 
 end
  
 function design = change(baseline,para,x)
 design = baseline;
 design(para)=x;
 end
 
 function [y] = rotate(data,angle)
 y = data;
 R = [cos(angle), -sin(angle); sin(angle), cos(angle)];%逆时针旋转
 y{1,2} = data{1,2}*R;
 for ii = [3,4,5]
    line = [data{1,ii}', data{2,ii}'];
    line = line*R;
    y{1,ii} = line(:,1)';
    y{2,ii} = line(:,2)';
 end
 
 end