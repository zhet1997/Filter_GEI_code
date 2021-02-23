%2019-7-19
%用于数据的提取
clc;clear
path = 'D:\study\工热会议\迁移学习算例20190707\result\';
 

lowfunc = 1;
    
number = 5;
addtype = 1;
for time = 1:10

load([path,num2str(lowfunc),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'])





 draw=time;
if opt.Sample.gen>1
%a = opt.Sample.initial_num_h;
a=0;

mm = min(opt.Sample.values_h(1:number,:));
% for i=opt.Sample.initial_num_h:opt.Sample.initial_num_h+opt.Sample.gen
% kk(i)=mean(opt.Sample.values_h(1:i,:));
% end

nn = opt.Sample.initial_num_l*0.1+opt.Sample.initial_num_h;

opt.value_min_record=[mm,opt.value_min_record];
opt.cost_record = [nn,opt.cost_record];

% plot(1:1:size(opt.corr1_record,2),opt.corr1_record,'r-','LineWidth',2);
% hold on;
% plot(1:1:size(opt.corr1_record,2),opt.corr1_record,'ro');
% hold on;
% 
% plot(1:1:size(opt.corr2_record,2),opt.corr2_record,'b-','LineWidth',2);
% hold on;
% plot(1:1:size(opt.corr2_record,2),opt.corr2_record,'bo');
% hold on;
% 
% plot(1:1:size(opt.corr3_record,2),opt.corr3_record,'g-','LineWidth',2);
% hold on;
% plot(1:1:size(opt.corr3_record,2),opt.corr3_record,'go');
% hold on;

plot(a:opt.Sample.gen+a,opt.value_min_record,'k-','LineWidth',2);
hold on
plot(a:opt.Sample.gen+a,opt.value_min_record,'ko');
hold on;

% plot(opt.cost_record,opt.value_min_record,'r-','LineWidth',2);
% hold on;
% plot(opt.cost_record,opt.value_min_record,'ro');
% hold on;

% plot(opt.Sample.initial_num_h:size(kk,2),kk(:,15:end),'b-','LineWidth',2);
% hold on;
% plot(opt.Sample.initial_num_h:size(kk,2),kk(:,15:end),'bo');
% hold on;

end

end

 
