clc;clear;
%% 
path_result = 'E:\dataset_final\';
path_option = 'E:\dataset_20190829\options_all\';
path_dus = 'D:\Users\ASUS\Desktop\invalid.txt';
path_output = 'E:\dataset_final\';
error_file = {};
%% 
dus = importdata(path_dus);%导入文件名
filename = cell(size(dus.data,1),2);
for ii = 1:size(dus.data,1)%复原文件名
    filename{ii,1} = dus.textdata{ii,1};
    filename{ii,2} = dus.data(ii,1);%算例编号
end

%% extend iterations

for ii = 1:size(dus.data,1)
for kk=1:dus.data(ii,2)
    filename_select = filename{ii,1};
    result_old = load ([path_result,filename_select,'%',num2str(filename{ii,2}),'.mat'],'opt');%导入原结果所有文件
    result_old = result_old.opt;
    
    option_old = load([path_option,filename_select,'.mat'],'option');
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




