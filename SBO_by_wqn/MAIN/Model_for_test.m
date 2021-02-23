%1forrester
%2branin   y_min=0.397887 at(-pi,12.275);(pi,2.275);(9.42478,2.475)
%3hartmann_3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at��4,4,4,4��
%6goldstein_price   y_min=3  at(0,-1);
%7hartmann_6D  y_min=-3.32237 at(0.20169,0.150011,0.476874,0.275332,0.311652,0.6573)
%���ݲɼ�ģ��

%2019-6-5
%������Ϊ���Ե�ģ����������ڲ�ͬ�㷨�벻ͬ���Ժ�����������
%�������²��֣�
%1.���Ժ���ѡȡ
%2.�Ż��㷨ѡȡ
%3.�㷨��������
%4.�Ż�������������
clear;clc
option = struct();
%�Բ�����������
%�Խṹ����ʽ���浽.mat�ļ��У�
option.path = 'E:\dataset_20190829\';
%====================================
option.date = datestr(datetime('today'),'yyyy-mm-dd');
%====================================
option.func.hi_fi = 'hartmann_6D';
option.func.low_fi = 'MA6';
option.func.errpara = 4.15;
%====================================
option.initial.num = [36,18];
option.model = 'CoKriging';
%'Filter_GEI'=='EI'== 'augmented_EI'=='VF-EI'=='GEI';
option.infill = 'Filter_GEI';
option.stop = 0.01;
option.max = 100;
%====================================
option.itermax = 80;
option.cluster_h = 0.1;
option.cluster_l = 0.05;
option.testtime = 1;

if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')==1
file_name = [option.date,'%',option.func.hi_fi,'&',option.func.low_fi,'&',num2str(option.func.errpara),'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'.mat'];
elseif  strcmp(option.model,'Kriging')==1
file_name = [option.date,'%',option.func.hi_fi,'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'.mat'];
else
error('����ķ������ڿ�ѡ��Χ��');
end

save([option.path,'option_bag\',file_name],'option');
disp('alredy save');