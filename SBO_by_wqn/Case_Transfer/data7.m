%2019-9-11
%�����ļ���ȡ
%ͳ�ư�һ��������������ʱ��ÿ�ּӵ㷽���ļӵ����
clc;clear;
%path = 'D:\study\���Ȼ���\Ǩ��ѧϰ����20190707\result\';
path = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\result0\';
%path = 'D:\study\���Ȼ���\Ǩ��ѧϰ����20190707\result\';

threshold = 0.0353;
aa=[];
bb=[];
for lowfunc =[0.7,0.8,0.9,1.0,1.1]
    a=zeros(1,5);
    b=zeros(1,5);
    ii=1;
for number = [5,10,20,30,40]
    s=[];v=[];
for addtype = [3]
    box = zeros(10,5);
for time = 1:10
    if addtype==0
        low=0;
    else
        low=lowfunc;
    end
   load([path,num2str(low),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'])
   m = min(opt.Sample.values_h(1:number,:));%��ʼ�ӵ����Сֵ
   box(time,1)=m;
   box(time,2:size(opt.value_min_record,2)+1)=opt.value_min_record;
end
    %s = [s;sum(box,1)/10];
    %v = [v;std(box,1,1)];
    box(box<threshold) = 0;
    box(box~=0) = 1;
    s = [s;sum(box(:,end))];
    v = [v;sum(box(:))+number*10-10];
    
end
    a(:,ii) = (10-s)/10;
    b(:,ii) = v;
    ii=ii+1;
end
aa=[aa;a];
bb=[bb;b];
end
bb=bb/10;
c = b./b(1,:);




