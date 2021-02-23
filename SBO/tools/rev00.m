function [y] = rev00(x)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
n = size(x,1);
y =zeros(n,14);
for i=1:n
    for j=1:7
    y(i,j) = x(i,j)-0.5;
    y(i,j) = 0.125*107*j + y(i,j)*(0.125*107-1.27);
    y(i,j) = y(i,j)/107;
    end
    for j=8:14
    y(i,j) = 1.5*x(i,j) + 0.5;
    end
end
end

