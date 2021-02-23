clc;clear;%hold off;
sam = Sample('mult','forrester','forrester1a',1,0,0);
sam.put_in('low',[0;0.15;0.3;0.45;0.85;1;0.6501;0.7320;0.2318;0.6945;0.2670;0.7563]);
sam.put_in('high',[0.1;0.9;0.65;0.6944;0.7318;0.7564]);
 
%sam.put_in('high',[0.05;0.4;0.5;0.6;0.7;0.9;1])
 mod = oodacefit( sam.points, sam.values, struct() );
 opt = Iteration(sam,mod);
 %=======================================================================
 opt.add_record = [6,3;3,1;2,1;1,1];
 opt.Sample.initial_num_h = 3;
 opt.Sample.initial_num_l = 6;

 
 %=====================================================================
[x,y]=opt.find_GEI(10);
        x0=x;
        x1=[];
        xx = x;
%         mm_ini = mean(opt.Sample.values_h(1:opt.Sample.initial_num_h));%初始加点平均数
%         mm = sum(opt.Sample.values_h(opt.Sample.initial_num_h+1:end))+mm_ini;
%         mm = mm/(opt.Sample.number_h-opt.Sample.initial_num_h+1);
          idx1 = cumsum(opt.add_record,1);
          idx2 = [0;idx1(1:end-1,2)]+1;
          idx2 = [idx2,idx1(:,2)];
          mm=[];
          for ii=1:4%这里也要手改啊
              if idx2(ii,1)<=idx2(ii,2)
          mm = [mm;mean(opt.Sample.values_h(idx2(ii,1):idx2(ii,2)))];
              end
          end
          mm = mean(mm);
        ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance()/opt.Model.GP{1}.getProcessVariance())+1);
        threshold = opt.y_min*ww + mm*(1-ww);
        for i=1:size(y,1)
            if y(i) <= threshold
                x1=[x1;x(i,:)];%筛选出，未聚类
            end
        end
        
        if size(x1,1)>1
            x2=opt.cluster2(x1,0.1);%聚类完毕
        else
            x2=x1;
        end
        
        s=[];
        for ii=1:size(x2,1)
            a = x-x2(ii);
            s  = [s;find(a(:,1)==0)];
        end
        x0(s,:)=[];
        
        x0=opt.cluster3(x0,0.05);
        
        x_h = x2;
        x_l = x0;
        
        clear('x1','x0','x2','mm_ini','mm','ww');
 %=======================================================================

x=linspace(0,1,1000);
y1=x;
y2=x;
z=x;

for i=1:1000
    [y1(i),z(i)]=opt.Model.predict(x(i));
    z(i)= sqrt(z(i));
    %z1(i)=y1(i)+z(i);
    %z2(i)=y1(i)-z(i);
    y2(i)= Testmodel(x(i),'forrester');
    
    
    zz(i)=normpdf(x(i),0,1);
end
%opt.g=10;

for i=1:1000
   [l1(i),w(i)]=opt.Model.GP{1}.predict(x(i));
    %w(i)= sqrt(w(i));
    %w1(i)=l1(i)+w(i);
    %w2(i)=w1(i)-w(i);
    %l2(i)= Testmodel(x(i),'forrester');
    l2(i) = Errormodel(x(i),3);
    %l2(i) = l2(i)/2;
    %ei_h(i) =- opt.EI_high(x(i));
    %ei_l(i) =- opt.EI_low(x(i));
end

%fill([x,fliplr(x)],[z1,fliplr(z2)],'c');
%hold on;


plot(x,y1,'k-','linewidth',1.5);

% [AX,H1,H2]=plotyy(x,y1,x,ei_h);%,'k-','linewidth',1.5);
%  set(AX(1),'XColor','k','YColor','b');
%  set(AX(2),'XColor','k','YColor','r');
% set(H1,'LineStyle','-','Color','k','linewidth',1.5);%设置右侧线型
% set(H2,'LineStyle','-','Color','r','linewidth',1);%设置左侧线型
%  set(get(AX(1),'Ylabel'),'String','Y') 
%  set(get(AX(2),'Ylabel'),'String','EI') 
%   set(AX(1),'ylim',[-10 20])
%  set(AX(2),'ylim',[-0.1 1])
%   set(AX(1),'ytick',-10:5:20)
%   set(AX(2),'ytick',0:0.2:1)
xlabel('X')
ylabel('Y')
hold on
plot(x,y2,'k--');
hold on
plot(opt.Sample.points_h(1:5,:),opt.Sample.values_h(1:5,:),'b.','MarkerSize',30);

hold on

set(gca,'FontSize',12);



%hl = legend('代理模型','真实模型','样本点','GEI函数值');
%set(hl,'box','off');



plot(x,l1,'r-','linewidth',1.5);
hold on
plot(x,l2,'r--');
hold on
plot(opt.Sample.points_l(1:11,:),opt.Sample.values_l(1:11,:),'m.','MarkerSize',30);

hold on
%plot(x,z1,'c-');
hold on
%plot(x,z2,'c-');
hold on
%legend('高精度代理模型','高精度模型','高精度样本点','低精度代理模型','低精度模型','低精度样本点');
%hl = legend('hi-fi predict','hi-fi func','hi-fi sample','low-fi predict','low-fi func','low-fi sampele');
plot(xx,opt.Model.predict(xx),'g+','MarkerSize',10);
 plot(linspace(0,1,100),linspace(threshold,threshold,100),'g--','linewidth',2);
 plot(xx,opt.Model.predict(xx),'g.','MarkerSize',20);
 hl = legend('hi-fi predict','hi-fi func','hi-fi sample','low-fi predict','low-fi func','low-fi sampele','potential sample');
set(hl,'box','off');
%=======================================
plot(opt.Sample.points_h(6,:),opt.Sample.values_h(6,:),'b+','MarkerSize',15);
plot(opt.Sample.points_l(12,:),opt.Sample.values_l(12,:),'m+','MarkerSize',15);



box off

% a=figure(2);
%  plot(x,ei_h,'k-','linewidth',1.5);
%  hold on
% %  plot(x,ei_l,'r-','linewidth',1.5);
% %  hold on
% set(gca,'FontSize',15);
% axis([0 1 -0.1 2]);
% legend('高精度EI','低精度EI');

% plot(x,y1,'k-','linewidth',1.5);
% hold on
% plot(x,y2,'k--');
% hold on
%axis([0 1 -15 20]);

