clc;clear;
num=5;
ad=2;


%for j=1:10
    
    points_l=lhsdesign(num*ad, 3);%���Ϊn*m�ľ���
    points_h = points_l;
    for i=1:num*(ad-1)
        y = pdist(points_h,'euclid');
        z = linkage(y,'single');
        p1 = z(1,1);%������ӽ���������֮һ
        p2 = z(1,2);%������ӽ���������֮һ
        d1 = sum((points_h(p1,:) - linspace(0.5,0.5,3)).^2);
        d2 = sum((points_h(p2,:) - linspace(0.5,0.5,3)).^2);
        
        if d1>d2%ѡ��������Ľ�����һ��ȥ��
            p = p2;
        else
            p = p1;
        end
        
        points_h(p,:) = [];%ȥ����p����
        
    end
    
   % ini_sample_box{1,j} = points_l;
%end


%save('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\sample30.mat','ini_sample_box')