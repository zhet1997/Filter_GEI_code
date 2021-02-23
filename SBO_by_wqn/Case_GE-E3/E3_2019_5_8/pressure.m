clc;clear;
path = 'D:\Users\ASUS\Desktop\毕业设计工程算例\数据\优化数据\';
file = 'out_pressure_far.dat';
data = importdata([path,file]);
data = data.data;
k=0;
p=0;
x=0.345744;
a=0.005;
for i = 1:size(data,1)
   if abs(data(i,1)-x)<a
       k = k+1;
       p = p+data(i,4);
   end
end

y=p/k;