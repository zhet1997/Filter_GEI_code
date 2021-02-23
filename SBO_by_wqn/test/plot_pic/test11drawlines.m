clc;clear;
sam = Sample('mult','forrester','forrester1a',1,0,0);
sam.put_in('low',[0;0.2;0.35;0.4;0.6;0.7;0.82;1;])
sam.put_in('high',[0;0.35;0.6;0.82])

%sam.put_in('high',[0.05;0.17;0.4;0.5;0.57;0.91;1])
%sam.put_in('low',[0;0.1;0.2;0.35;0.85;1;0.2525;0.5511;0.65;0.2193;0.3792;0.6835])
%sam.put_in('high',[0.05;0.95;0.65;0.5856;0.6761;0.2193;0.7396])

 mod = oodacefit( sam.points, sam.values, struct() );
 opt = Iteration(sam,mod);

 sam2 = Sample('high','forrester',0);
 sam2.put_in('high',[0;0.35;0.6;0.82])
 
 mod2 = oodacefit( sam2.points, sam2.values, struct() );
 opt2= Iteration(sam2,mod2);
 
x=linspace(0,1,1000);
y1=x;
y2=x;
z=x;

for i=1:1000
    [y1(i),z(i)]=opt.Model.predict(x(i));
     [y3(i),~]=opt2.Model.predict(x(i));
    z(i)= sqrt(z(i));
    z1(i)=y1(i)+z(i);
    z2(i)=y1(i)-z(i);
    y2(i)= Testmodel(x(i),'forrester');
end
opt.g=10;

for i=1:1000
    [l1(i),w(i)]=opt.Model.GP{1}.predict(x(i));
%     w(i)= sqrt(w(i));
%     w1(i)=l1(i)+w(i);
%     w2(i)=w1(i)-w(i);
    %l2(i)= Testmodel(x(i),'forrester');
    l2(i) = Errormodel(x(i),3);
    %l2(i) = l2(i)/2;
    ei_h(i) =- opt.GEI_high(x(i));
    ei_l(i) =- opt.EI_low(x(i));
    
    
    ta(i) = Errormodel(x(i),3);
    tb(i) = Errormodel(x(i),4);
    tc(i) = Errormodel(x(i),5);
end

%fill([x,fliplr(x)],[z1,fliplr(z2)],'c');
%hold on;




ylabel('Function Value(y)')
xlabel('Design Variable(x)')
hold on
plot(x,y2,'k-','linewidth',2);
plot(x,y1,'r--','linewidth',2);
hold on
plot(opt.Sample.points_h,opt.Sample.values_h,'ks','MarkerFaceColor','k','markersize',13,'MarkerEdgeColor','k');
hold on

plot(x,y3,'b--','linewidth',2);
% 
% plot(x,ta,'r:','linewidth',2);
% plot(x,tb,'b:','linewidth',2);
% plot(x,tc,'g:','linewidth',2);
set(gca,'FontSize',15);
%legend('Forrester1','Forrester1a','Forrester1b','Forrester1c');




%plot(x,l1,'r-','linewidth',1.5);
hold on
plot(x,l2,'g--','linewidth',2);
hold on
plot(opt.Sample.points_l,opt.Sample.values_l,'g.','MarkerSize',40);
hold on
% plot(x,z1,'c-');
% hold on
% plot(x,z2,'c-');
% hold on
 %legend('高精度代理模型','高精度模型','高精度样本点','低精度代理模型','低精度模型','低精度样本点');
%box off
% a=figure(2);
%  plot(x,ei_h,'k-','linewidth',1.5);
%  hold on
% %  plot(x,ei_l,'r-','linewidth',1.5);
% %  hold on
% set(gca,'FontSize',15);
% axis([0 1 -0.1 2]);
% legend('高精度EI','低精度EI');
box on
% plot(x,y1,'k-','linewidth',1.5);
% hold on
% plot(x,y2,'k--');
% hold on
%axis([0 1 -15 20]);