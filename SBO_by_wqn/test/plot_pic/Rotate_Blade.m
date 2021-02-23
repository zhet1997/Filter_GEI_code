%2020-6-18
%旋转叶型型线使其轴向弦长水平；
clc;clear;
%% 输入数据
path = 'D:\Users\ASUS\Desktop\';
filename = 'E3_unrotated.dat';
profile = importdata([path,filename]);

%% 确定前缘与尾缘位置
leading_point = profile(1,1:2);%前缘
trailing_point = profile(end,1:2);%尾缘
delta = leading_point - trailing_point;
angle = atan(delta(2)/delta(1));

%% 旋转
%draw(profile);
draw(rotate(profile, angle));


function [y] = rotate(profile, angle)
R = [cos(angle), -sin(angle); sin(angle), cos(angle)];%逆时针旋转
y = [profile(:,1:2)*R, profile(:,3:4)*R];
end

function draw(profile)
n = size(profile,1);
plot(profile(1:n,1),profile(1:n,2),'r-','linewidth',1);hold on
plot(profile(1:n,3),profile(1:n,4),'b-','linewidth',1);
axis equal 
box off
end
