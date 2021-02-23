%2020-6-18
%��תҶ������ʹ�������ҳ�ˮƽ��
clc;clear;
%% ��������
path = 'D:\Users\ASUS\Desktop\';
filename = 'E3_unrotated.dat';
profile = importdata([path,filename]);

%% ȷ��ǰԵ��βԵλ��
leading_point = profile(1,1:2);%ǰԵ
trailing_point = profile(end,1:2);%βԵ
delta = leading_point - trailing_point;
angle = atan(delta(2)/delta(1));

%% ��ת
%draw(profile);
draw(rotate(profile, angle));


function [y] = rotate(profile, angle)
R = [cos(angle), -sin(angle); sin(angle), cos(angle)];%��ʱ����ת
y = [profile(:,1:2)*R, profile(:,3:4)*R];
end

function draw(profile)
n = size(profile,1);
plot(profile(1:n,1),profile(1:n,2),'r-','linewidth',1);hold on
plot(profile(1:n,3),profile(1:n,4),'b-','linewidth',1);
axis equal 
box off
end
