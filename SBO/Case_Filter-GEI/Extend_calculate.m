%2020-5-13
%��������Ŀ���Ƕ��Ѿ�����Ż��ļ�¼�ļ����н�һ�����ӳ����㡣
clc;clear;
%% ��ַ����
path_result = 'E:\dataset_final\';%���ԭ����ĵ�ַ%����������
path_option = 'E:\dataset_20190829\options_all\';%���ѡ��ĵ�ַ
path_dus = 'D:\Users\ASUS\Desktop\invalid.txt';%��ȡĿ¼�ĵ�ַ
path_output = 'E:\dataset_final\';%����½���ĵ�ַ
error_file = {};
%% ��������
dus = importdata(path_dus);%�����ļ���
filename = cell(size(dus.data,1),2);
for ii = 1:size(dus.data,1)%��ԭ�ļ���
    filename{ii,1} = dus.textdata{ii,1};
    filename{ii,2} = dus.data(ii,1);%�������
end

%% ��ʼ��������

for ii = 1:size(dus.data,1)
for kk=1:dus.data(ii,2)
    filename_select = filename{ii,1};
    result_old = load ([path_result,filename_select,'%',num2str(filename{ii,2}),'.mat'],'opt');%����ԭ��������ļ�
    result_old = result_old.opt;
    
    option_old = load([path_option,filename_select,'.mat'],'option');%����ԭѡ���ļ�
    option_old = option_old.option;
    
    try
        option_old.path = path_output;
        option_old.filename = [filename{ii,1},'%',num2str(filename{ii,2}),'.mat'];
        EGO_extend(option_old,result_old);
        disp('done');
    catch
        error_file = [error_file;{[filename{ii,1},filename{ii,2}]}];
     end
    
end
disp(['case',num2str(ii),'is calculated']);
end



