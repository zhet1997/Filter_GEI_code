%2019-7-3
% 1.Kriging����EI����45��ʼ��������С����ɾȥ���е���ģ�
% 2.Cokriging����EI����210��tip�������롪��45��ʼ��������С����ɾȥ���е���ģ�        p
% 3.Cokriging����EI����210��tip�������롪��45��ʼ��������С����ɾȥ��tipֵ��ģ�       v
% 4.Cokriging����EI����210��tip�������롪��45��ʼ��������210��tip������ֱ��ѡ��С�ģ�  m
%
% 5.Kriging����EI����',num2str(number),'��ʼ��������С����ɾȥ���е���ģ�
% 6.Cokriging����EI����210��tip�������롪��',num2str(number),'��ʼ��������С����ɾȥ���е���ģ�
% 7.Cokriging����EI����210��tip�������롪��',num2str(number),'��ʼ��������С����ɾȥ��tipֵ��ģ�
% 8.Cokriging����EI����210��tip�������롪��',num2str(number),'��ʼ��������210��tip������ֱ��ѡ��С�ģ�
%
% 9.Kriging����EI����105��ʼ��������С����ɾȥ���е���ģ�
% 10.Cokriging����EI����210��tip�������롪��105��ʼ��������С����ɾȥ���е���ģ�
% 11.Cokriging����EI����210��tip�������롪��105��ʼ��������С����ɾȥ��tipֵ��ģ�
% 12.Cokriging����EI����210��tip�������롪��105��ʼ��������210��tip������ֱ��ѡ��С�ģ�

%����hub������Ż�
%ʹ�ò�ͬ����ģ��
%ʹ��EI�ӵ�׼��
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
%     path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190706\';
%     filename = ['hub (',num2str(task),')\iter_new_points.dat'];
%     wdat([importdata([path2,filename]);x],[path2,filename])%��������д�룬�����ں������
% end
% path3 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190706\�ļ�ģ��\';
% wdat(x_box,[path3,'gen.dat']);
% msgbox('�������������', '�Ի���');

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


function [ini_h,all_l]=loadin(task)%������Ҫ����Ϣ
path1 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190702\source\';
path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190702\';
number = fix((task-0.5)/4)*30 +45;
 
switch task
    case {1 5 9}  %k-p
        %����;�����Ϣ
        all_l = [];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\p_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\p_ini_high_values_',num2str(number),'.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case {2 6 10}%p
        %����;�����Ϣ
        all_l = [importdata([path1,'ini_points_210.dat']),importdata([path1,'tip_ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\p_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\p_ini_high_values_',num2str(number),'.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case {3 7 11}%v
        %����;�����Ϣ
           all_l = [importdata([path1,'ini_points_210.dat']),importdata([path1,'tip_ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\v_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\v_ini_high_values_',num2str(number),'.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
    case {4 8 12}%m
        %����;�����Ϣ
          all_l = [importdata([path1,'ini_points_210.dat']),importdata([path1,'tip_ini_values_210.dat'])];
        %����߾��ȳ�ʼ��Ϣ
        ini_h = [importdata([path1,'hub\m_ini_high_points_',num2str(number),'.dat']),importdata([path1,'hub\m_ini_high_values_',num2str(number),'.dat'])];
        %����߾��ȼӵ���Ϣ
        add_h = [importdata([path2,'hub (',num2str(task),')\iter_new_points.dat']),importdata([path2,'hub (',num2str(task),')\iter_new_values.dat'])];
        %�ϳ�
        all_h = [ini_h;add_h];
        
        %===================================================================================================================
        
        
        
end
end

