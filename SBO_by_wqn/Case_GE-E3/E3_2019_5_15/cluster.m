clc;clear;
path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190601\';
file0 = 'tip\ini_points_210.dat';
file1 = 'tip\ini_values_210.dat';

file2 = 'tip\iter_points.dat';
file3 = 'tip\iter_values.dat';

%file3 = 'hub\ini_values_210.dat';
dat_t0 = importdata([path,file0]);
val_t0 = importdata([path,file1]);

dat_t = importdata([path,file2]);
val_t = importdata([path,file3]);


data271 = [dat_t0;dat_t];
val271 = [val_t0;val_t];
for i=1:61
    y = pdist(data271,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%������ӽ���������֮һ
    p2 = z(1,2);%������ӽ���������֮һ
    d1 = sum((data271(p1,:) - linspace(0.5,0.5,7)).^2);
    d2 = sum((data271(p2,:) - linspace(0.5,0.5,7)).^2);
    
%     if d1>d2%ѡ��������Ľ�����һ��ȥ��
%         p = p2;
%     else
%         p = p1;
%     end

    if val271(p1)<= val271(p2)%ѡ��tipֵ�����һ��ȥ��
        p = p2;
    else
        p = p1;
    end

    %val_t(p,:)=[];
    data271(p,:) = [];%ȥ����p����
    val271(p,:) = [];
   
end

