clc;clear;
path = 'D:\Users\ASUS\Desktop\independence.dat';
aa = load(path);
x = aa(1:end,1)/100000;
y1 = aa(1:end,2);
y2 = aa(1:end,3);

hold on;
[AX,H1,H2] =plotyy(x,y1,x,y2);% »ñÈ¡×ø±êÖá¡¢Í¼Ïñ¾ä±ú
%plotyy(x,y1,x,y2);

plot(linspace(0.12141,0.12141,100),linspace(0.02,0.11,100),'k--','linewidth',1);
plot(linspace(1.00701,1.00701,100),linspace(0.02,0.11,100),'k--','linewidth',1);
 set(get(AX(1),'ylabel'),'string', 'Energy Loss\times 10^{-1}','fontsize',12,'color','k');
 set(get(AX(2),'ylabel'),'string', 'Reynolds Number \times 10^5','fontsize',12,'color','k');
xlabel('Number of cells \times 10^5 ','fontsize',12);
set(AX(1),'Ycolor','r')
set(AX(2),'Ycolor','b')
set(AX(1),'ylim',[0.02 0.11]);   % ×ø±êÖá·¶Î§
set(AX(1),'ytick',[0.02:0.01:0.11]) %×ø±êÖá¿Ì¶È
set(AX(1),'yticklabel',[0.02:0.01:0.11]/0.1)
set(AX(2),'ylim',[950000 995000]);
set(AX(2),'ytick',[950000:5000: 995000])
set(AX(2),'yticklabel',[950000:5000: 995000]/100000)
%set(AX(2),'yticklabel',['9.50 \times 10^5'])
%set(AX(1),'box','off')
%set(AX(2),'box','off')

set(AX(1),'xlim',[-20000 230000]/100000);
set(AX(2),'xlim',[-20000 230000]/100000);
set(AX(2),'xtick',[-20000: 20000 : 230000]/100000)
set(AX(2),'xticklabel',[-20000: 20000 : 230000]/100000)
set(AX(1),'xtick',[-20000: 20000 : 230000]/100000)
set(AX(2),'xticklabel',[-20000: 20000 : 230000]/100000)

set(H1,'Linestyle','-','linewidth',1);
set(H2,'Linestyle','-','linewidth',1);
set(H1,'Marker','.','Markersize',20);
set(H2,'Marker','square','MarkerFaceColor','b');
set(H1,'color','r');
set(H2,'color','b');

set(gcf,'unit','centimeters','position',[10 5 12 10])



%
% set(gcf,'color','white')
% set(gca,'linewidth',1.5) %ÉèÖÃ±ß¿ò¿í¶È  
