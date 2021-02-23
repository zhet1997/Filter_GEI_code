%2020-6-3
%用于绘制Filter-GEI论文中的示意图
clc;clear; %hold off;
% HF_set_ini = [0.1;0.65;0.9];
% %HF_set_ini = [0.2;0.6;1];
% LF_set_ini = [0.1;0.4;0.5;0.8;0.9];
% 
% HF_set = HF_set_ini;
% LF_set = LF_set_ini;
% sam = Sample('mult','forrester','forrester1a',1,0,0);
% sam.put_in('low',LF_set);
% sam.put_in('high',HF_set);
% 
% Data = cell(4,5);%模型；本级HF;本机LF;本级potential;本级threshold
% 
% opt = Iteration(sam,mod);
% opt.add_record = [5,size(HF_set_ini,1)];
% opt.Sample.initial_num_h = size(HF_set_ini,1);
% opt.Sample.initial_num_l = 5;
% 
% save(['E:\SBO_by_wqn\Case_Filter-GEI\data_draw\','iter1.mat'],'opt');
% Data{1,1} = opt;
% Data{1,2} =  HF_set_ini;
% Data{1,3} = LF_set_ini;
% 
% for iteration=1:5%修改
%     %fprintf("这是第%d次迭代\n",iteration);
%     [x_l,x_h,p,threshold]=FGEI(opt);%选择加点位置
%     opt.Update(x_l,x_h); %更新模型
%     opt.record;%记录模型
%     opt.result;%输出当前结果
%     
%     save(['E:\SBO_by_wqn\Case_Filter-GEI\data_draw\','iter',num2str(iteration+1),'.mat']);
%     Data{iteration+1,1} = opt;
%     Data{iteration+1,2} = x_h;
%     Data{iteration+1,3} = x_l;
%     Data{iteration+1,4} = p;
%     Data{iteration+1,5} =threshold;
%     % 判断是否收敛
% end
% for ii =1:4
%     temp = load(['E:\SBO_by_wqn\Case_Filter-GEI\data_draw\','iter',num2str(ii),'.mat']);
%     Data{ii,1} = temp.opt;
% end

load(['E:\SBO_by_wqn\Case_Filter-GEI\data_draw\','demo3','.mat']);
%save(['E:\SBO_by_wqn\Case_Filter-GEI\data_draw\','demo3','.mat'],'Data');

for ii=1:4
figure();    
draw(Data{ii,1},Data{ii+1,2},Data{ii+1,3},Data{ii+1,4},Data{ii+1,5},ii)
end

%% 画图
function draw(opt,x_h,x_l,p,threshold,ii)
dense = 1000;
x=linspace(0,1,dense);
y_h_predict=x;
y_h_real=x;
y_l_predict=x;
y_l_real=x;

%获取所需的数据线
for i=1:dense
    [y_h_predict(i),~]=opt.Model.predict(x(i));
    y_h_real(i)= Testmodel(x(i),'forrester');
    [y_l_predict(i),~]=opt.Model.GP{1}.predict(x(i));
    y_l_real(i) = Errormodel(x(i),3);
end
%开始画线
plot(x,y_h_predict,'k-','linewidth',1.5);hold on
plot(x,y_h_real,'k--');
plot(opt.Sample.points_h(:,:),opt.Sample.values_h(:,:),'b.','MarkerSize',30);%所有高精度样本

plot(x,y_l_predict,'r-','linewidth',1.5);
plot(x,y_l_real,'r--');
plot(opt.Sample.points_l(:,:),opt.Sample.values_l(:,:),'m.','MarkerSize',30);%所有低精度样本

if ii~=4
plot(p,opt.Model.predict(p),'gs','MarkerSize',12,'linewidth',2);
%plot(p,opt.Model.predict(p),'k+','MarkerSize',10);
plot(linspace(0,1,100),linspace(threshold,threshold,100),'g--','linewidth',2);

%最新加入的样本
[y_h,~]=opt.Model.predict(x_h);
[y_l,~]=opt.Model.GP{1}.predict(x_l);
plot(x_h,y_h,'bo','MarkerSize',8,'linewidth',1);
plot(x_l,y_l,'mo','MarkerSize',8,'linewidth',1);
end

%图框属性设置
axis([-0.05 1.05 -10 20])
xlabel('X')
ylabel('Y')
set(gca,'FontSize',12);
hl = legend('HF predict','HF func','HF sample','LF predict','LF func','LF sampele','Sample candidate','Threshold','Location','NorthWest');
set(hl,'box','off');
box on
set(gcf,'unit','centimeters','position',[10 10 12 10])
end

function [x_l,x_h,x,threshold] = FGEI(opt)%输入为Iteration对象
[x,y]=opt.find_GEI(8);%计算GEI结果样本

x_h = [];
x_l = [];

gen = opt.Sample.gen+1;
idx1 = cumsum(opt.add_record,1);
idx2 = [0;idx1(1:end-1,2)]+1;
idx= [idx2,idx1(:,2)];
y_mean = zeros(gen,1);

for ii=1:gen%
    if idx(ii,1)<=idx(ii,2)
        y_mean(ii) = mean(opt.Sample.values_h(idx(ii,1):idx(ii,2)));
    end
end

y_mean = mean(y_mean);
ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance()/opt.Model.GP{1}.getProcessVariance())+1);
threshold = opt.y_min*ww + y_mean*(1-ww);

for i=1:size(y,1)%筛选
    if y(i) <= threshold
        x_h=[x_h;x(i,:)];%筛选出，未聚类
    end
end

if size(x_h,1)>1
    x_h = opt.cluster2(x_h,0.1);%聚类完毕
end

s=[];
x_l = x;
for ii=1:size(x_h,1)
    a = x-x_h(ii);
    s = [s;find(a(:,1)==0)];
end
x_l(s,:)=[];

if size(x_l,1)>1
    x_l = opt.cluster3(x_l,0.05);
end

end
