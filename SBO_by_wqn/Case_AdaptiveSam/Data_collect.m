 %2020-4-9
%用于导入数据
%考虑到图片的一致性，在这篇论文中仍然使用matlab作图
%以后这种非核心算法功能都要到python上去
clc;clear;
k = [54,54,54,21,21,21];
for ii = 1:30
    path_case = ['D:/Users/ASUS/Desktop/Case_20200619/Case_' , num2str(ii) , '/'];
    path_point = [path_case , 'Points/'];
    path_value = [path_case , 'Values/'];
    for jj = 1:k(idivide(ii-1,int32(5))+1)
        try
            v_h{jj,ii} = load([path_value,'iter',num2str(jj-1),'_h.dat']);
        catch
            v_h{jj,ii} = []; %如果没有这个文件就跳过这一轮
        end
        v_l{jj,ii} = load([path_value,'iter',num2str(jj-1),'_l.dat']);
        p_h{jj,ii} = load([path_point,'iter',num2str(jj),'_h.dat']);
        p_l{jj,ii} = load([path_point,'iter',num2str(jj),'_l.dat']);
    end
end
aaa = number(v_l);
v_h2 = optimal(shape(v_h));
data_h = v_h;
% save('D:\Users\ASUS\Desktop\Result20200629.mat','data');
% plot(1:20,v_h2,'r-'); hold on;
% errorbar((1:20)+0.3,mean(v_h2(1:20,1:10),2),std(v_h2(1:20,1:10),0,2),'r-','Linewidth',2);hold on
%clear('v_h','v_l','p_h','p_l');
% for ii = 11:30
%     path_case = ['D:/Users/ASUS/Desktop/Case_20200619/Case_' , num2str(ii) , '/'];
%     path_point = [path_case , 'Points/'];
%     path_value = [path_case , 'Values/'];
%     for jj = 1:12
%         try
%             v_h{jj,ii-10} = load([path_value,'iter',num2str(jj-1),'_h.dat']);
%         catch
%             v_h{jj,ii-10} = []; %如果没有这个文件就跳过这一轮
%         end
%         v_l{jj,ii-10} = load([path_value,'iter',num2str(jj),'_l.dat']);
%         p_h{jj,ii-10} = load([path_point,'iter',num2str(jj),'_h.dat']);
%         p_l{jj,ii-10} = load([path_point,'iter',num2str(jj),'_l.dat']);
%     end
% end

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

function y=shape(data)

bac = ones(150,size(data,2));
for ii=1:size(data,2)
temp=cell2mat(data(:,ii));
bac(1:size(temp,1),ii)=temp;
end
y = bac;
end

function y=shape2(data)

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
