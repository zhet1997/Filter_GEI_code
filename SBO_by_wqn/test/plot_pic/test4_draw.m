clc;clear



%���Ժ�������
func_name ='ackley';
%�㷨����
algo_type ='CoKriging';
%��ʼ�ӵ�
ini_number = 15;
ini_number_l=90;
%�ӵ㷽��
%add_type = 'VF_EI';
add_type = 'Filter_GEI';
%add_type = 'augmented_EI';

a=figure(1);

%title('hartmann3D ������Cokriging EI�ӵ㲻ͬ��ʼ��Ա�', 'FontSize', 14);
%title('Shekel������GEI�ӵ�Ա�', 'FontSize', 14);
%title('Shekel ������EI�ӵ㲻ͬ�;��Ⱥ����Ա�', 'FontSize', 14);
%title('branin����EI�����Ƿ��ҵ�����ֵ����', 'FontSize', 14);
%title('Ackley����', 'FontSize', 14);
   % xlabel('�߾��ȼӵ���', 'FontSize', 14);
    %xlabel('��������', 'FontSize', 14);
    %ylabel('�߾��ȼӵ�ƽ��ֵ', 'FontSize', 14);
 
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

 
