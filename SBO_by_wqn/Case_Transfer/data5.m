%2019-7-2
%所有文件提取
%这个是用来画迭代收敛图的
%clc;clear;
path = 'D:\study\工热会议\迁移学习算例20190707\result\';
hold off
for lowfunc =0.9
    a=zeros(3,21,5);
    b=zeros(3,21,5);
    ii=1;
for number = [5,10,30]
    s=[];v=[];
for addtype = [0,1,3]
    boxx = zeros(10,5);
for time = 1:10
    if addtype==0
        low=0;
    else
        low=lowfunc;
    end
   load([path,num2str(low),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'])
   m = min(opt.Sample.values_h(1:number,:));%初始加点后最小值
   boxx(time,1)=m;
   boxx(time,2:21)=opt.value_min_record;
end
    s = [s;sum(boxx,1)/10];
    v = [v;std(boxx,1,1)];
end
    a(:,:,ii) = s;
    b(:,:,ii) = v;
    ii=ii+1;
end
end
hold off
c = linspecer(3);
k = [5,10,30];
for j=1:3
    subplot(3,1,j);
    
for i=1:3
  if (j==2)  
      ylabel('Optimal value');
        %ylabel('最优样本值');
  end
axis([-0.5 20.5 0.0350 0.03649]);
errorbar((0:20)+0.1*i,a(i,:,j),0.5*b(i,:,j),'color',c(i,:),'Linewidth',1.5);hold on
box off
if j~=3
set(gca,'Xtick',[]);
set(gca,'XTickLabel',{});
end
tt=['Initial Number -',num2str(k(j))];
%tt=['初始加点个数-',num2str(k(j))];
t=title(tt,'position',[10,0.0362]);
set(t,'FontSize',20)

end
end


for i = 1:3
H(i)=subplot(3,1,i);    %第NN张子图
PPP=get(H(i),'pos');      %第NN张子图的当前位置PPP是一个1×4的行向量，
PPP=PPP+[0,-(3-i)*0.04,0,0];      %宽向右边延展0.04
set(H(i),'pos',PPP)        %根据新的边界设置。
end
%==================================================================
% l = legend('无迁移','加点方式1','加点方式2');%,'加点方式3');
% set(l,'FontSize',10)
% set(l, 'Box', 'off');
% 
%  xlabel('迭代次数');
%  ylabel('最优样本值');
%==================================================================
l = legend('No Transfer','Remove dense','Pick optimal');%,'加点方式3');
%l = legend('无迁移','加点方式1','加点方式2');
set(l,'FontSize',10)
set(l, 'Box', 'off');

 xlabel('Iteration');
 %xlabel('迭代次数');
 %ylabel('Optimal value');
 %================================================================

% %c=['k','r','b','g'];
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
% end
% 
% %axis([0.9 5.1 0.0351 0.036])
% axis([0.9 5.1 0.0351 0.037])
% 
% l = legend('无迁移-5次迭代结果','加点方式1-5次迭代结果','加点方式2-5次迭代结果','加点方式3-5次迭代结果',...
% '无迁移-10次迭代结果','加点方式1-10次迭代结果','加点方式2-10次迭代结果','加点方式3-10次迭代结果',...
% '无迁移-10次迭代结果','加点方式1-10次迭代结果','加点方式2-10次迭代结果','加点方式3-10次迭代结果');
% set(l,'FontSize',10)
% set(l, 'Box', 'off');
% xlabel('初始目标任务样本数');
% ylabel('最优样本值');
% tt='出口马赫数为0.9作为迁移来源';
% title(tt);
% 
% set(gca,'Xtick',[1 2 3 4 5]);
% set(gca,'XTickLabel',{'5','10','20','30','40'});
% 
% 



% set(gcf,'Position',[100 100 260 220]);
% set(gca,'Position',[.13 .17 .80 .74]);
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);













