%2020-4-9
%用于整理数据
%考虑到图片的一致性，在这篇论文中仍然使用matlab作图
%以后这种非核心算法功能都要到python上去
clc;clear;
% for ii = 1:10
%     path_case = ['D:/Users/ASUS/Desktop/Case_20200421/Case_' , num2str(ii) , '/'];
%     path_point = [path_case , 'Points/'];
%     path_value = [path_case , 'Values/'];
%     for jj = 1:20
%         try
%             v_h{jj,ii} = load([path_value,'iter',num2str(jj),'_h.dat']);
%         catch
%             v_h{jj,ii} = []; %如果没有这个文件就跳过这一轮
%         end
%         v_l{jj,ii} = load([path_value,'iter',num2str(jj),'_l.dat']);
%         p_h{jj,ii} = load([path_point,'iter',num2str(jj),'_h.dat']);
%         p_l{jj,ii} = load([path_point,'iter',num2str(jj),'_l.dat']);
%     end
% end
% v_h2 = optimal(cell2mat(v_h));
% % plot(1:20,v_h2,'r-'); hold on;
%  errorbar((1:20)+0.3,mean(v_h2(1:20,1:10),2),std(v_h2(1:20,1:10),0,2),'r-','Linewidth',2);hold on
% clear('v_h','v_l','p_h','p_l');
for ii = 1:20
    path_case = ['D:/Users/ASUS/Desktop/Case_20200421/Case_' , num2str(ii) , '/'];
    path_point = [path_case , 'Points/'];
    path_value = [path_case , 'Values/'];
    for jj = 1:23
        try
            v_h{jj,ii} = load([path_value,'iter',num2str(jj-1),'_h.dat'])-0.0001;
        catch
            v_h{jj,ii} = []; %如果没有这个文件就跳过这一轮
        end
        v_l{jj,ii} = load([path_value,'iter',num2str(jj),'_l.dat']);
        p_h{jj,ii} = load([path_point,'iter',num2str(jj),'_h.dat']);
        p_l{jj,ii} = load([path_point,'iter',num2str(jj),'_l.dat']);
    end
end
 v_h2 = optimal(shape2(v_h));
  v_l2 = optimal(shape(v_l));
  aaa =  number(v_l);
%   plot(1:20,v_h2(1:20,11:20)-0.00001,'g-'); hold on;
%    plot(1:20,v_h2(1:20,21:30)-0.00002,'k-'); hold on;
%    plot(1:20,v_h2(1:20,1:10)-0.00003,'b-'); hold on;
errorbar(1:20,mean(v_h2(1:20,1:10),2),std(v_h2(1:20,1:10),0,2),'y-','Linewidth',2);hold on
   errorbar((1:20)+0.2,mean(v_h2(1:20,11:20),2),std(v_h2(1:20,11:20),0,2),'m-','Linewidth',2);hold on
   %errorbar((1:8)+0.1,mean(v_h2(1:8,21:30),2),std(v_h2(1:8,21:30),0,2),'k-','Linewidth',2);hold on
   
   
   l=legend('EI','VF-EI','augmented-EI','Filter-GEI');
    set(l,'FontSize',20)
   ylabel('最优值');
   xlabel('高精度加点数');
   %xlabel('迭代次数');
   axis([0 21 0.034 0.037])
 %clear('v_h','v_l','p_h','p_l');

function y=optimal(data)
for ii = 1:size(data,2)
    for jj=2:size(data,1)
        if data(jj,ii)>=data(jj-1,ii)
            data(jj,ii)=data(jj-1,ii);
        end
    end
end
y = data;
end

function y=shape(data)%按高精度

bac = ones(50,size(data,2));
for ii=1:size(data,2)
temp=cell2mat(data(:,ii));
bac(1:size(temp,1),ii)=temp;
end
y = bac;
end

function y=shape2(data)%按迭代

bac = ones(50,size(data,2));
for ii=1:size(data,2)
    for jj=1:size(data,1)
if isempty(data{jj,ii})
    bac(jj,ii)=0.037;
else
    bac(jj,ii)=min(data{jj,ii});
end
    end
end
y = bac;
end

function y= number(data)
bac = zeros(50,size(data,2));
for ii=1:size(data,2)
    for jj=1:size(data,1)
if isempty(data{jj,ii})
    bac(jj,ii)=0;
else
    bac(jj,ii)=size(data{jj,ii},1);
end
    end
end
y = bac;
end
