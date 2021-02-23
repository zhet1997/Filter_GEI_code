clc;clear;
%load('D:\Users\ASUS\Desktop\ano.mat');
%data = box{1,1};


%plot(1:201,data);
c = linspecer(3);
x = [9,62,28];
pie(x);
labels = {'length of axial chord','outlet deflect angle','control point coefficient'};
legend(labels)
colormap(c);