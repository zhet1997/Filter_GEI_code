%2019-7-26
%统计响应面精度最高与迭代收敛最快的相关度
%三维加点
clc;clear;
path = 'D:\study\工热会议\迁移学习算例20190707\';
relate = importdata([path,'relate.dat']);
relate1 = reshape(relate(:,6),10,4,5,5);
relate2 = reshape(relate(:,7),10,4,5,5);

ac=0;

path = 'D:\study\工热会议\迁移学习算例20190707\result\';
sss = zeros(5,5);
zz=1;
for lowfunc =[0.7,0.8,0.9,1,1.1] %[1,1.1]%
    ii=1;%代表加代数
for number = [5,10,20,30,40]
     box = zeros(10,4);
    jj=1;%代表加点方式
for addtype = [0,1,2,3]
   
for time = 1:10
    if addtype==0
        low=0;
    else
        low=lowfunc;
    end
   load([path,num2str(low),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'])
   box(time,jj)=opt.value_min_record(10);%%%key point
   
end
    jj=jj+1;
end
    box2  = relate1(:,:,ii,zz);
    box3  = relate2(:,:,ii,zz);
    
    for kk =1:4
    c = linspecer(4);
    plot3(box3(:,kk),box2(:,kk),box(:,kk),'.','color',c(kk,:),'markersize',20);hold on
   %plot(box3(:,kk),box2(:,kk),'.','color',c(kk,:),'markersize',30);hold on
    ac = ac+1;
    end   
%     for kk=1:10
%         
%         q1=find(box(kk,:)==min(box(kk,:)));
%         q2=find(box2(kk,:)==max(box2(kk,:)));
%         q3=find(box3(kk,:)==min(box3(kk,:)));
%         if length(q2)==1&&length(q3)==1
%             if  q2==q3
%                 num=num+1;
%             end
%         else
%            disp('多个最优值');
%             %num=num+1;
%         end
%     end
   
ii=ii+1;
end
zz=zz+1;

end

l = legend('无迁移','加点方式1','加点方式2','加点方式3');
set(l,'FontSize',10)
set(l, 'Box', 'off');

xlabel('RSME');
ylabel('Spearman');

% axis([0 0.002  -0.8 1 0.03515 0.0354])
% axis([ 0.0351 0.0358 0.0001 0.002])

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














