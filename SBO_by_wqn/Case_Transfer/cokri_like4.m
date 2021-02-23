%2019-7-19
%�������Ӧ�澫��
%==========================================================================
clc;clear;
%��ȡ�봢��·��
path1 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190707\surf\';
path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190707\';
path3 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20190707\result\';
%����ѡ��
box =[];
for lowfunc = [0.7,0.8,0.9,1.0,1.1]

    
inform.lowfunc=lowfunc;


%���ظߵ;�����Ӧ��mat�ļ�
load([path1,'res_surf',num2str(0.6),'.mat'],'mod');
fun_h = mod;
load([path1,'res_surf',num2str(lowfunc),'.mat'],'mod');

fun_l = mod;
clear('mod');


%��ʼ������Ӧ�澫��
density=0.05;
for i=1:3
    eval(['x',num2str(i),'=0:',num2str(density),':1;']);
    eval(['xx{1,',num2str(i),'}=x',num2str(i),';']);
end
gridx = makeEvalGrid(xx);
gridy1 = fun_h.predict(gridx);%ԭģ������
gridy2 = fun_l.predict(gridx);%����ģ������


%�������ϵ��
corr1 = corr(gridy1,gridy2,'type' , 'pearson');
corr2 = corr(gridy1,gridy2,'type' , 'Spearman');

%������������
temp = gridy1-gridy2;
temp = temp'*temp;
mse = sqrt(temp/size(gridx,1));

    
box = [box;lowfunc,corr1,corr2,mse];   
end






