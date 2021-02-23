clc;clear;
iter = 20;
t1 = clock;
%2020-6-20
%���й���������������
%clc;clear;
add_box = [];
num_box = [];
for case_i =1:15
    %% �������
    %iter = 5; %��0��ָ0�ε����ĵ�λ������ֵ��ȫ��ã�Ϊ�˵õ��µļӵ㡣
    %��iter=20��ʼFilter_GEI�������Ż�
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path_save = ['D:/Users/ASUS/Desktop/Case_20200619/Case_',num2str(case_i),'/Points/'];
    path_load = ['D:/Users/ASUS/Desktop/Case_20200619/Case_',num2str(case_i),'/Values/'];
   %% ��������
    v_h = [];
    %v_l = [];
    p_h = [];
    p_l = [];
    for ii=0:iter
       
        %v_l = [v_l;load([path_load,'iter',num2str(ii),'_l.dat'])];
        p_h = [p_h;load([path_save,'iter',num2str(ii),'_h.dat'])];
        p_l = [p_l;load([path_save,'iter',num2str(ii),'_l.dat'])];
        try
            num = size(load([path_save,'iter',num2str(ii),'_h.dat']),1);
            vh_new =  load([path_load,'iter',num2str(ii),'_h.dat']);
            v_h = [v_h;vh_new(1:num)];
        catch
            v_h = v_h; %���û������ļ���������һ��
       end
    end
    load('D:\Users\ASUS\Desktop\��������0616\LF������Ӧ��/LF_surf.mat');
    v_l = mod.predict(p_l);
    clear('mod');
    %% ����ģ��
    sam = Sample('mult','E3_7',0,0);
    sam.put_in('all_h',[p_h,v_h]);
    sam.put_in('all_l',[p_l,v_l]);
    if case_i>=6&&case_i<=10
        mod = krigingfamily( sam.points, sam.values,'HierarchicalKriging');
    else
        mod = krigingfamily( sam.points, sam.values,'CoKriging');
    end
    opt = Iteration(sam,mod);
    %% ����ӵ�
    if case_i>=1&&case_i<=5%GEI
        [add_points_l, add_points_h] = infill2(opt,'augmented_EI');
    elseif case_i>=6&&case_i<=10%Filter_GEI
        [add_points_l, add_points_h] = infill2(opt,'VF_EI');
    elseif case_i>=11&&case_i<=15%Filter_GEI
        [add_points_l, add_points_h] = infill2(opt,'EI');
    elseif case_i>=16&&case_i<=20%Filter_GEI
        [add_points_l, add_points_h] = infill2(opt,'GEI');
    elseif case_i>=21&&case_i<=25%Filter_GEI
        [add_points_l, add_points_h] = infill2(opt,'Filter_GEI0.1');
    elseif case_i>=26&&case_i<=30%Filter_GEI
        [add_points_l, add_points_h] = infill2(opt,'Filter_GEI0.05');
    end
        %% ��������
        filename_h = ['iter',num2str(iter+1),'_h.dat'];
        filename_l = ['iter',num2str(iter+1),'_l.dat'];
       % wdat(add_points_h,[path_save,filename_h])%��������д�룬�����ں������ %����߾��ȼӵ�λ��
      %  wdat(add_points_l,[path_save,filename_l])%��������д�룬�����ں������ %����߾��ȼӵ�λ��
        
        load('D:\Users\ASUS\Desktop\��������0616\LF������Ӧ��/LF_surf.mat')
        if isempty(add_points_l)
            v_l = [];
        else
            v_l = mod.predict(add_points_l);
        end
        clear('mod');
       % wdat(v_l,[path_load,filename_l])%��������д�룬�����ں������;
        
       add_box = [add_box; add_points_h];
       num_box = [num_box; size(add_points_h,1)];
end
    num_box = cumsum(num_box);
t2 = clock;
PF_Time = etime(t1,t2);
     %wdat(add_box,'D:\Users\ASUS\Desktop\Case_20200619\Template\gen.dat');%��������д�룬�����ں������
     %wdat(num_box,'D:\Users\ASUS\Desktop\Case_20200619\Template\num.dat');%��������д�룬�����ں������
    disp('task is done');
    y = num_box;

