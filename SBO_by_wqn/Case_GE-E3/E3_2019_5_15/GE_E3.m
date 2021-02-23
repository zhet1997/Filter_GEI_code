%2019_5_8
%��������������ʵ����GE_E3ҶƬ�����е�����ת��
%������ʽ1��Ҷ��ʵ�ʲ�����Ҳ����ֱ������TBDO������
%������ʽ2��Ҷ���Ż�������Ҳ����Ҷ������ڲο�Ҷ�ͱ仯�İٷֱȲ���
%������ʽ3����һ��������Ҳ���ǽ�����Ӧ��Ĳ�����ʽ

clc;clear;
path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����\';
file = 'tip\ini_points_210.dat';
dat3 = importdata([path,file]);
dat1 = change_3to1('tip',dat3);
data = change_1to3('hub',dat1);

function data1 = change_3to1(sec,data3)
    %ȷ������λ�ã����زο���ֵ
    data1 = data3;
    path =  'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����\';
    Ref = importdata([path,'ref.dat']);
    switch sec
        case 'tip'
            ref = Ref(:,3);
        case 'pitch'
            ref = Ref(:,2);
        case 'hub'
            ref = Ref(:,1);
    end
     boud = Ref(:,4:5);
     for i = 1:7
     boud(i,1) = ref(i)+boud(i,1);
     boud(i,2) = ref(i)+boud(i,2);
     end
     for i=1:7 %6������
        data1(:,i) = data3(:,i)*(boud(i,2)- boud(i,1))+ boud(i,1);
     end
end

function data3 = change_1to3(sec,data1)
    data3 = data1;
    path =  'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����\';
    Ref = importdata([path,'ref.dat']);
    switch sec
        case 'tip'
            ref = Ref(:,3);
        case 'pitch'
            ref = Ref(:,2);
        case 'hub'
            ref = Ref(:,1);
    end
     boud = Ref(:,4:5);
     for i = 1:7
     boud(i,1) = ref(i)+boud(i,1);
     boud(i,2) = ref(i)+boud(i,2);
     end
     for i=1:7 %6������
        data3(:,i) = (data1(:,i)- boud(i,1))/(boud(i,2)- boud(i,1));
     end
end
