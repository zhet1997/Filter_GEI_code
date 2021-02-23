%1forrester
%2branin   y_min=0.397887 at(-pi,12.275);(pi,2.275);(9.42478,2.475)
%3hartmann_3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at��4,4,4,4��
%6goldstein_price   y_min=3  at(0,-1);
%7hartmann_6D  y_min=-3.32237 at(0.20169,0.150011,0.476874,0.275332,0.311652,0.6573)
%���ݲɼ�ģ��

%2019-9-21
%������Ϊ���Ե�ģ����������ڲ�ͬ�㷨�벻ͬ���Ժ�����������
%�������²��֣�
%1.���Ժ���ѡȡ
%2.�Ż��㷨ѡȡ
%3.�㷨��������
%4.�Ż�������������
function index_in(put)
option = struct();
%�Բ�����������
option.path = 'E:\dataset_20200528\';
%====================================
option.date = datestr(datetime('today')+2,'yyyy-mm-dd');
%====================================
option.func.hi_fi = put{1};
option.func.low_fi = put{2};
option.func.errpara = put{3};
%====================================
option.initial.num = [put{4},put{5}];
option.model = put{6};
%'Filter_GEI'=='EI'== 'augmented_EI'=='VF-EI'=='GEI';
option.infill = put{7};
option.stop = put{8};
option.max = put{9};
%====================================
option.itermax = put{10};
option.cluster_h = put{11};
option.cluster_l = put{12};
option.testtime = 1;

if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')==1
file_name = [option.date,'%',option.func.hi_fi,'&',option.func.low_fi,'&',num2str(option.func.errpara),'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'.mat'];
elseif  strcmp(option.model,'Kriging')==1
file_name = [option.date,'%',option.func.hi_fi,'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'.mat'];
else
error('����ķ������ڿ�ѡ��Χ��');
end

save(['E:\dataset_20190829\option_bag8\',file_name],'option');
disp('alredy save');