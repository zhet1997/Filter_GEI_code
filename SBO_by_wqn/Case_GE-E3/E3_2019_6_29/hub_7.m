%2019-7-1
% 1.Kriging——EI——75初始采样（最小距离删去离中点近的）
% 2.Cokriging——EI——271个tip样本全加——75初始采样（最小距离删去离中点近的）
% 3.Cokriging——EI——210个tip样本加入——75初始采样（最小距离删去离中点近的）
% 4.Cokriging——EI——210个tip聚类加入（留小去大）——75初始采样（最小距离删去离中点近的）
%
% 5.Cokriging——EI——271个tip样本全加——75初始采样（最小距离删去离tip值大的）
% 6.Cokriging——EI——210个tip样本加入——75初始采样（最小距离删去离tip值大的）
% 7.Cokriging——EI——210个tip聚类加入（留小去大）——75初始采样（最小距离删去离tip值大的）
%用于hub截面的优化
%使用不同代理模型
%使用EI加点准则
clc;clear;
x_box = zeros(25,8,7);

% for task = 1:7
%     [data_h,data_l] = loadin(task);
%     
%     
%     if task==1
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
%     path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20190701\';
%     filename = ['hub (',num2str(task),')\iter_new_points.dat'];
%     wdat([importdata([path2,filename]);x],[path2,filename])%这是整个写入，而非在后面加上
% end
% path3 = 'D:\Users\ASUS\Desktop\迁移学习算例20190701\文件模板\';
% wdat(x_box,[path3,'gen.dat']);
% msgbox('计算结束啦！！', '对话框');
 for task = 1:7
[data_h,~] = loadin(task);
x_box(:,:,task) = data_h;
 end
 
 for i=1:7
 plot(1:25,x_box(:,8,i))
 hold on 
 end
 

function [add_h,all_l]=loadin(task)%载入需要的信息
path1 = 'D:\Users\ASUS\Desktop\迁移学习算例20190701\source\';
path2 = 'D:\Users\ASUS\Desktop\迁移学习算例20190701\';
switch task
    case 1
        %载入低精度信息
        all_l = [];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (1)\iter_new_points.dat']),importdata([path2,'hub (1)\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case 2
        %载入低精度信息
        ini_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        add_l = [importdata([path1,'tip\iter_points.dat']),importdata([path1,'tip\iter_values.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (2)\iter_new_points.dat']),importdata([path2,'hub (2)\iter_new_values.dat'])];
        %合成
        all_l = [ini_l;add_l];
        all_h = [ini_h;add_h];
    case 3
        %载入低精度信息
        all_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (3)\iter_new_points.dat']),importdata([path2,'hub (3)\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case 4
        %载入低精度信息
        all_l = [importdata([path1,'tip\cluster_ini_points_210.dat']),importdata([path1,'tip\cluster_ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (4)\iter_new_points.dat']),importdata([path2,'hub (4)\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case 5
        %载入低精度信息
        ini_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        add_l = [importdata([path1,'tip\iter_points.dat']),importdata([path1,'tip\iter_values.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\v_ini_high_points_75.dat']),importdata([path1,'hub\v_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (5)\iter_new_points.dat']),importdata([path2,'hub (5)\iter_new_values.dat'])];
        %合成
        all_l = [ini_l;add_l];
        all_h = [ini_h;add_h];
    case 6
        %载入低精度信息
        all_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\v_ini_high_points_75.dat']),importdata([path1,'hub\v_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (6)\iter_new_points.dat']),importdata([path2,'hub (6)\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
    case 7
        %载入低精度信息
        all_l = [importdata([path1,'tip\cluster_ini_points_210.dat']),importdata([path1,'tip\cluster_ini_values_210.dat'])];
        %载入高精度初始信息
        ini_h = [importdata([path1,'hub\v_ini_high_points_75.dat']),importdata([path1,'hub\v_ini_high_values_75.dat'])];
        %载入高精度加点信息
        add_h = [importdata([path2,'hub (7)\iter_new_points.dat']),importdata([path2,'hub (7)\iter_new_values.dat'])];
        %合成
        all_h = [ini_h;add_h];
        
        
end
end

