%2019-7-3
% 1.Kriging——EI——45初始采样（最小距离删去离中点近的）
% 2.Cokriging——EI——210个tip样本加入——45初始采样（最小距离删去离中点近的）        p
% 3.Cokriging——EI——210个tip样本加入——45初始采样（最小距离删去离tip值大的）       v
% 4.Cokriging——EI——210个tip样本加入——45初始采样（从210个tip采样中直接选最小的）  m
%
% 5.Kriging——EI——',num2str(number),'初始采样（最小距离删去离中点近的）
% 6.Cokriging——EI——210个tip样本加入——',num2str(number),'初始采样（最小距离删去离中点近的）
% 7.Cokriging——EI——210个tip样本加入——',num2str(number),'初始采样（最小距离删去离tip值大的）
% 8.Cokriging——EI——210个tip样本加入——',num2str(number),'初始采样（从210个tip采样中直接选最小的）
%
% 9.Kriging——EI——105初始采样（最小距离删去离中点近的）
% 10.Cokriging——EI——210个tip样本加入——105初始采样（最小距离删去离中点近的）
% 11.Cokriging——EI——210个tip样本加入——105初始采样（最小距离删去离tip值大的）
% 12.Cokriging——EI——210个tip样本加入——105初始采样（从210个tip采样中直接选最小的）

%用于hub截面的优化
%使用不同代理模型
%使用EI加点准则
clc;clear;
% x_box = zeros(12,7);
% 
% for task =1: 12
%     [data_h,data_l] = loadin(task);
%     
%     
%     if (task==1||task==5||task==9)
%         sam = Sample('high','E3',0);
%         sam.put_in('all_h',data_h);
%     else
%         sam = Sample('mult','E3',0,0);
%         sam.put_in('all_h',data_h);
%         sam.put_in('all_l',data_l);
%     end
%     mod = oodacefit( sam.points, sam.values, struct());
%     opt = Iteration(sam,mod);
%     [x,~]=opt.select_EI('high');
%     
%     x_box(task,:) = x;
%     
%     
%     path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20190706\';
%     filename = ['hub (',num2str(task),')\iter_new_points.dat'];
%     wdat([importdata([path2,filename]);x],[path2,filename])%这是整个写入，而非在后面加上
% end
% path3 = 'D:\Users\ASUS\Desktop\迁移学习算例20190706\文件模板\';
% wdat(x_box,[path3,'gen.dat']);
% msgbox('计算结束啦！！', '对话框');

%=========================
%x_box = zeros(30,8,12);
x_box = zeros(12,1);
 for task = 1:12
[data_h,~] = loadin(task);
x_box(task) = min(data_h(:,8));
 end

 for i=1:12
 plot(1:30,x_box(:,8,i))
 hold on
 end


function [ini_h,all_l]=loadin(task)%载入需要的信息
path1 = 'D:\Users\ASUS\Desktop\迁移学习算例20190702\source\';
path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20190702\';
number = fix((task-0.5)/4)*30 +45;
 
switch task
    case {1 5 9}  %k-p
        %载入低精度信息
        all_l = [];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\p_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\p_ini_high_values_',num2str(number),'.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case {2 6 10}%p
        %载入低精度信息
        all_l = [importdata([path1,'ini_points_210.dat']),importdata([path1,'tip_ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\p_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\p_ini_high_values_',num2str(number),'.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case {3 7 11}%v
        %载入低精度信息
           all_l = [importdata([path1,'ini_points_210.dat']),importdata([path1,'tip_ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\v_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\v_ini_high_values_',num2str(number),'.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case {4 8 12}%m
        %载入低精度信息
          all_l = [importdata([path1,'ini_points_210.dat']),importdata([path1,'tip_ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\m_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\m_ini_high_values_',num2str(number),'.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
        
        %===================================================================================================================
        
        
        
end
end

