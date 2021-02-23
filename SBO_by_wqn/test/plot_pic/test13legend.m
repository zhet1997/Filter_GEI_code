x = 1:10;
y = x;
hold on
%plot(x,y2,'k-','linewidth',2);
plot(x,y,'ks-','MarkerFaceColor',...
'k','markersize',13,'MarkerEdgeColor','k','linewidth',2);

%plot(x,l2,'g--','linewidth',2);
plot(x,y,'g.--','MarkerSize',40,'linewidth',2);


plot(x,y,'b--','linewidth',2);
plot(x,y,'r--','linewidth',2);

l=legend('HF Function with samples ','LF Function with samples ',...
'Surrogate with only HF samples','Multi-fidelity Surrogate');
set(l,'FontSize',15);

axis([0 100 0 100])