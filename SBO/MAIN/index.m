%2019-9-21
clc;clear;
path = 'E:\dataset_20190829\option_bag\';
[~,~,table] = xlsread([path,'index.xlsx'],7);
table = table(2:end,:);

for ii = 1:size(table,1)
put = table(ii,:);
index_in(put);
end