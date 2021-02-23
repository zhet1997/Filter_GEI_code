%2019-9-21
%用于处理计算的结果
%Filter-GEI论文相关；

clc;clear;
path = 'D:\Users\ASUS\Desktop\英语论文\dataset_final\';
a = dir([path,'*.mat']);
%a = dir( 'E:\dataset_20190829\option_bag6\*.mat');
for ii = 1:length(a)
    c{ii,:} = a(ii).name;
    c{ii,:} = strrep(c{ii,:},'.mat','');
end

for ii = 1:20%1:length(a)
    filename = c{ii,:};
    sta = Statistics(filename);
    sta.load();
    sta.get_av();
    sta.out('result');
    disp('done');
end