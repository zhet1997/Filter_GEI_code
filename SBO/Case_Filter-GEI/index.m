function index(filename)

xlsPath = '.\Demo\';
[~,~,table] = xlsread([xlsPath,filename],1);
table = table(2:end,:);

for ii = 1:size(table,1)
put = table(ii,:);
index_in(put,xlsPath);
end

end