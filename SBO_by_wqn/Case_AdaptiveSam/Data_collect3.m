%2020-4-23
%处理完整的数据
clc;clear;
hold off
%依次为：
%1.EI
%2.Filter_GEI(0.05)
%3.VF-EI
%4.augmented-EI
%5.Filter_GEI(0.05)
%6.Filter_GEI(0.1)
%load('D:\Users\ASUS\Desktop\Result20200423_2.mat','data2');
% load('D:\Users\ASUS\Desktop\Result20200625.mat','data');
% data_2 = data;
load('D:\Users\ASUS\Desktop\Result20200703.mat','data_h','data_l');
%调整顺序
% data2(:,1:10)=data(:,1:10);
% data2(:,11:30)=data(:,21:40);
% data2(:,31:40)=data(:,41:50);
% %data2(:,31:40)=data(:,11:20);
% data2(:,41:50)=data(:,51:60);
data = data_h;
data2(:,1:5)=data(:,26:30);%filter-GEI
data2(:,6:10)=data(:,16:20);
data2(:,11:15)=data(:,11:15);
data2(:,16:20)=data(:,1:5);
data2(:,21:25)=data(:,6:10);
data2(:,3) = data(:,22);

data = data_l;
data3(:,1:5)=data(:,26:30);%filter-GEI
data3(:,6:10)=data(:,16:20);
data3(:,11:15)=data(:,11:15);
data3(:,16:20)=data(:,1:5);
data3(:,21:25)=data(:,6:10);
data3(:,3:4) = data(:,24:25);


%data=data_GEI;
data=data2;
% data_EI = data2(:,1:10);
% data_VF = data2(:,11:20);
% data_aug = data2(:,21:30);
% data_FGEI=data2(:,41:50);
% data_temp = cell(30,10);
% data_temp(1:18,1:10)=data_GEI;
% data=[data_FGEI,data_aug,data_EI,data_temp,data_VF];
%data = data2;

shape=1;


if shape==1
v_h = optimal(shape1(data));
num = 57;%计算多少步
else
v_h = optimal(shape2(data));
num = 20;%计算多少步
end

nn = number(data);
% nnn = sum(nn(1:num,:),1);
nnnn = cumsum(nn(:,:),1);

n2 = cumsum(number(data3),1);

data_mean=[];
data_std=[];
data_min=[];
data_max=[];
data_num=[];
data_iter = [];
data_lf = [];

b = [];
c = [];
for ii=1:25
a = find(nnnn(:,ii)>=56);
try
b = [b, a(1)];
c = [c, n2(a(1),ii)];
catch
b = [b,56];  
c = [c, n2(56,ii)];
end
end




for ii=1:5
round =  (1:5)+(ii-1)*5;
v_mean = mean(v_h(1:num,round),2);
v_std = std(v_h(1:num,round),0,2);
v_min = min(v_h(1:num,round),[],2);
v_max = max(v_h(1:num,round),[],2);
%v_num = mean(nnn(1,round));
v_iter = mean(b(1,round));
v_lf = mean(c(1,round));

data_mean = [data_mean,v_mean];
data_std = [data_std,v_std];
data_min = [data_min,v_min];
data_max = [data_max,v_max];
%data_num = [data_num,v_num];
data_iter = [data_iter,v_iter];
data_lf = [data_lf, v_lf];
end

c = linspecer(6);
b = {'-o','-^','-','--',':'};
%b = {'o','k','^','*','+','o'};
%b = {'-','-','-','-','-'};
%plot(1:20,data_mean')
for jj=1:5
%plot(1:21+0.1*jj,data_mean(:,jj),'Color',c(jj,:),'Linewidth',1.5);hold on
if jj==7
if shape==1
errorbar(1:size(data_mean(21:end,jj),1),data_mean(21:end,jj),data_std(21:end,jj)/2,'Color',c(jj,:),'Linewidth',1.5);hold on
else
errorbar((1:21),data_mean(:,jj),data_std(:,jj)/2,'Color',c(jj,:),'Linewidth',1.5);hold on
end

else
if shape==1
plot(1:size(data_mean(21:end,jj),1),data_mean(21:end,jj),b{jj},'Color',c(jj,:),'Linewidth',1.5,'markersize',3);hold on
%plot(1:size(data_mean(21:end,jj),1),data_mean(21:end,jj),d{jj},'Color',c(jj,:),'Linewidth',1.5);hold on
else
plot(1:num,data_mean(:,jj),b{jj},'Color',c(jj,:),'Linewidth',1.5);hold on
end
end
% if shape==1
% plot(1:21+0.1*jj,data_std(5:end,jj),'Color',c(jj,:),'Linewidth',1.5);hold on
% else
% plot(1:21+0.1*jj,data_std(:,jj),'Color',c(jj,:),'Linewidth',1.5);hold on
%end

end


%l=legend('EI','VF-EI','augmented-EI','Filter-GEI(0.05)','Filter-GEI(0.1)');
%l=legend('Filter-GEI(0.05)','Filter-GEI(0.1)','GEI');
%l=legend('VF-EI','agumented-EI','EI','GEI','Filter-GEI','Filter-GEI','Location','NorthEast');
l=legend('Filter-GEI','GEI','EI','VF-EI','agumented-EI','Location','NorthEast');
set(l,'FontSize',12)
set(l,'box','off')
ylabel('Optimal Value','FontSize',12);
 %ylabel('Standard Deviation','FontSize',12);
if shape==1
    xlabel('HF numbers','FontSize',12);
else
    xlabel('Iteration','FontSize',12);
end
%
% axis([0 22 0 1.2e-3]) 
 axis([0 38 0.027 0.0286])
 %box off
 box on
set(gcf,'unit','centimeters','position',[10 10 12 9])

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

function y=shape1(data)%按高精度

bac = ones(150,size(data,2));
for ii=1:size(data,2)
temp=cell2mat(data(:,ii));
bac(1:size(temp,1),ii)=temp;
end
y = bac;
end

function y=shape2(data)%按迭代

bac = ones(150,size(data,2));
for ii=1:size(data,2)
    for jj=1:size(data,1)
if isempty(data{jj,ii})
    bac(jj,ii)=bac(jj-1,ii);
else
    bac(jj,ii)=min(data{jj,ii});
end
    end
end
y = bac;
end

function y= number(data)
bac = zeros(150,size(data,2));
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