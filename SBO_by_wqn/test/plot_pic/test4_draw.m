clc;clear



%测试函数名称
func_name ='ackley';
%算法类型
algo_type ='CoKriging';
%初始加点
ini_number = 15;
ini_number_l=90;
%加点方法
%add_type = 'VF_EI';
add_type = 'Filter_GEI';
%add_type = 'augmented_EI';

a=figure(1);

%title('hartmann3D 函数的Cokriging EI加点不同初始点对比', 'FontSize', 14);
%title('Shekel函数的GEI加点对比', 'FontSize', 14);
%title('Shekel 函数的EI加点不同低精度函数对比', 'FontSize', 14);
%title('branin函数EI方法是否找到最优值区域', 'FontSize', 14);
%title('Ackley函数', 'FontSize', 14);
   % xlabel('高精度加点数', 'FontSize', 14);
    %xlabel('迭代次数', 'FontSize', 14);
    %ylabel('高精度加点平均值', 'FontSize', 14);
 
for draw=1:10
    
path1 = 'E:\ooDACE\DATA\databox_2019_8_21\';

path2 = [func_name,'\',algo_type,'\'];
%path2 = [func_name,'_best\',algo_type,'\'];

file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(draw),'.mat'];
load([path1,path2,file_name]);
if opt.Sample.gen>1

%a = opt.Sample.initial_num_h;
a=0;

mm = min(opt.Sample.values_h(1:opt.Sample.initial_num_h,:));
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

plot(a:opt.Sample.gen+a,opt.value_min_record,'r-','LineWidth',2);
hold on;
plot(a:opt.Sample.gen+a,opt.value_min_record,'ro');
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

 
