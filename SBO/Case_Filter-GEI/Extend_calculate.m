%2020-5-13
%本函数的目的是对已经完成优化的记录文件进行进一步的延长计算。
clc;clear;
%% 地址设置
path_result = 'E:\dataset_final\';%存放原结果的地址%啊啊啊啊啊
path_option = 'E:\dataset_20190829\options_all\';%存放选项的地址
path_dus = 'D:\Users\ASUS\Desktop\invalid.txt';%提取目录的地址
path_output = 'E:\dataset_final\';%输出新结果的地址
error_file = {};
%% 导入数据
dus = importdata(path_dus);%导入文件名
filename = cell(size(dus.data,1),2);
for ii = 1:size(dus.data,1)%复原文件名
    filename{ii,1} = dus.textdata{ii,1};
    filename{ii,2} = dus.data(ii,1);%算例编号
end

%% 开始继续计算

for ii = 1:size(dus.data,1)
for kk=1:dus.data(ii,2)
    filename_select = filename{ii,1};
    result_old = load ([path_result,filename_select,'%',num2str(filename{ii,2}),'.mat'],'opt');%导入原结果所有文件
    result_old = result_old.opt;
    
    option_old = load([path_option,filename_select,'.mat'],'option');%导入原选项文件
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




