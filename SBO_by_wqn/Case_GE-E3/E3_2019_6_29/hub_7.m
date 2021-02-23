%2019-7-1
% 1.Kriging����EI����75��ʼ��������С����ɾȥ���е���ģ�
% 2.Cokriging����EI����271��tip����ȫ�ӡ���75��ʼ��������С����ɾȥ���е���ģ�
% 3.Cokriging����EI����210��tip�������롪��75��ʼ��������С����ɾȥ���е���ģ�
% 4.Cokriging����EI����210��tip������루��Сȥ�󣩡���75��ʼ��������С����ɾȥ���е���ģ�
%
% 5.Cokriging����EI����271��tip����ȫ�ӡ���75��ʼ��������С����ɾȥ��tipֵ��ģ�
% 6.Cokriging����EI����210��tip�������롪��75��ʼ��������С����ɾȥ��tipֵ��ģ�
% 7.Cokriging����EI����210��tip������루��Сȥ�󣩡���75��ʼ��������С����ɾȥ��tipֵ��ģ�
%����hub������Ż�
%ʹ�ò�ͬ����ģ��
%ʹ��EI�ӵ�׼��
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
%     path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190701\';
%     filename = ['hub (',num2str(task),')\iter_new_points.dat'];
%     wdat([importdata([path2,filename]);x],[path2,filename])%��������д�룬�����ں������
% end
% path3 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190701\�ļ�ģ��\';
% wdat(x_box,[path3,'gen.dat']);
% msgbox('�������������', '�Ի���');
 for task = 1:7
[data_h,~] = loadin(task);
x_box(:,:,task) = data_h;
 end
 
 for i=1:7
 plot(1:25,x_box(:,8,i))
 hold on 
 end
 

function [add_h,all_l]=loadin(task)%������Ҫ����Ϣ
path1 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190701\source\';
path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190701\';
switch task
    case 1
        %����;�����Ϣ
        all_l = [];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (1)\iter_new_points.dat']),importdata([path2,'hub (1)\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case 2
        %����;�����Ϣ
        ini_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        add_l = [importdata([path1,'tip\iter_points.dat']),importdata([path1,'tip\iter_values.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (2)\iter_new_points.dat']),importdata([path2,'hub (2)\iter_new_values.dat'])];
        %�ϳ�
        all_l = [ini_l;add_l];
        all_h = [ini_h;add_h];
    case 3
        %����;�����Ϣ
        all_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (3)\iter_new_points.dat']),importdata([path2,'hub (3)\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case 4
        %����;�����Ϣ
        all_l = [importdata([path1,'tip\cluster_ini_points_210.dat']),importdata([path1,'tip\cluster_ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\p_ini_high_points_75.dat']),importdata([path1,'hub\p_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (4)\iter_new_points.dat']),importdata([path2,'hub (4)\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case 5
        %����;�����Ϣ
        ini_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        add_l = [importdata([path1,'tip\iter_points.dat']),importdata([path1,'tip\iter_values.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\v_ini_high_points_75.dat']),importdata([path1,'hub\v_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (5)\iter_new_points.dat']),importdata([path2,'hub (5)\iter_new_values.dat'])];
        %�ϳ�
        all_l = [ini_l;add_l];
        all_h = [ini_h;add_h];
    case 6
        %����;�����Ϣ
        all_l = [importdata([path1,'tip\ini_points_210.dat']),importdata([path1,'tip\ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\v_ini_high_points_75.dat']),importdata([path1,'hub\v_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (6)\iter_new_points.dat']),importdata([path2,'hub (6)\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case 7
        %����;�����Ϣ
        all_l = [importdata([path1,'tip\cluster_ini_points_210.dat']),importdata([path1,'tip\cluster_ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\v_ini_high_points_75.dat']),importdata([path1,'hub\v_ini_high_values_75.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (7)\iter_new_points.dat']),importdata([path2,'hub (7)\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
        
        
end
end

