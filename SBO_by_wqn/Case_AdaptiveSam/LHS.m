clc;clear;
num=21;
ad=2;
path = 'D:\Users\ASUS\Desktop\��������0616\LF������Ӧ��\';

% for j=1:10
%     
%     points_l=lhsdesign(num*ad, 7);%���Ϊn*m�ľ���
%     points_h = points_l;
%     for i=1:num*(ad-1)
%         y = pdist(points_h,'euclid');
%         z = linkage(y,'single');
%         p1 = z(1,1);%������ӽ���������֮һ
%         p2 = z(1,2);%������ӽ���������֮һ
%         d1 = sum((points_h(p1,:) - linspace(0.5,0.5,7)).^2);
%         d2 = sum((points_h(p2,:) - linspace(0.5,0.5,7)).^2);
%         
%         if d1>d2%ѡ��������Ľ�����һ��ȥ��
%             p = p2;
%         else
%             p = p1;
%         end
%         
%         points_h(p,:) = [];%ȥ����p����
%         
%     end
%     
%    % ini_sample_box{1,j} = points_l;
% wdat(points_h,[path,'\LHS_ini\iter0_h',num2str(j),'.dat']);
% wdat(points_l,[path,'\LHS_ini\iter0_l',num2str(j),'.dat']);
% disp('done');
% end

%=========================
% points = importdata([path,'LF_response_surf.dat']);
% values = importdata([path,'LF_result.dat']);
% 
%  mod = krigingfamily( points, values,'Kriging');
% aaaa = 10.^mod.getHyperparameters();
%===========================

box = [];
v_all = [];
for jj =1:5
    j = mod(jj,5);
    if j==0
        j=5;
    end
    path_save = ['D:/Users/ASUS/Desktop/Case_20200619/Case_',num2str(jj),'/Values/'];
    aa = importdata(['D:\Users\ASUS\Desktop\��������0616\LHS_ini\iter0_h',num2str(j),'.dat']);
    %box = [box;aa];
    load('D:\Users\ASUS\Desktop\��������0616\LF������Ӧ��/LF_surf.mat')
    v_l = mod.predict(aa);
    clear('mod');
    filename_l = 'iter0_l.dat';
    v_all = [v_all;v_l];
    %wdat(v_l,[path_save,filename_l])%��������д�룬�����ں������ %����߾��ȼӵ�λ��
end
% % 

%save('D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\sample30.mat','ini_sample_box')