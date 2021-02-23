%2019-7-3
clc;clear;
path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190706\source\';
file0 = 'ini_points_210.dat';
file1 = 'tip_ini_values_210.dat';
file2 = 'pitch_ini_values_210.dat';
file3 = 'hub_ini_values_210.dat';

point_ini = importdata([path,file0]);
val_t = importdata([path,file1]);
val_p = importdata([path,file2]);
val_h = importdata([path,file3]);

%Ҫ����ı���
points = point_ini;
values = val_h;
%Ҫ����ĸ���
number = 105;
for i=1:210-number
    
    %==================================================
    y = pdist(points,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%������ӽ���������֮һ
    p2 = z(1,2);%������ӽ���������֮һ
    d1 = sum((points(p1,:) - linspace(0.5,0.5,7)).^2);
    d2 = sum((points(p2,:) - linspace(0.5,0.5,7)).^2);
    
%     if d1>d2%ѡ��������Ľ�����һ��ȥ��
%         p = p2;
%     else
%         p = p1;
%     end

    if val_t(p1)<= val_t(p2)%ѡ��tipֵ�����һ��ȥ��
        p = p2;
    else
        p = p1;
    end
     
    %====================================================
    
%     p=find(val_t==max(val_t));%�ҵ�����һ��
%     p=p(1);%�����ж����ֻ����һ��

    val_t(p,:)=[];
    points(p,:) = [];%ȥ����p����
    values(p,:) = [];
   
end

wdat(points,['D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190706\source\pitch\v_ini_high_points_',num2str(number),'.dat']);
wdat(values,['D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190706\source\pitch\v_ini_high_values_',num2str(number),'.dat']);


