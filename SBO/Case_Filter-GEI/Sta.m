%2019-9-21
%���ڴ������Ľ��
%Filter-GEI������أ�

clc;clear;
path = 'D:\Users\ASUS\Desktop\Ӣ������\dataset_final\';
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