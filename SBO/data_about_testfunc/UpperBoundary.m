%2020-11-16
%��һ�º������Ͻ�
clc;clear;

dim = 5;
g_down=zeros(dim,1);
g_up=ones(dim,1);
border=[g_down,g_up];

name = 'ackley';
func = @(x) Testmodel(x,name)*-1;


[location,y] = ga(func,dim,[],[],[],[],border(:,1),border(:,2));