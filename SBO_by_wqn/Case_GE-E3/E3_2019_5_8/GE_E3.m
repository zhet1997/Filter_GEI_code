%2019_5_8
%本函数的作用是实现在GE_E3叶片过程中的数据转化
%数据形式1：叶型实际参数，也就是直接输入TBDO的数据
%数据形式2：叶型优化参数，也就是叶型相对于参考叶型变化的百分比参数
%数据形式3：归一化参数，也就是建立响应面的参数格式

clc;clear;
path = 'D:\Users\ASUS\Desktop\毕业设计工程算例\数据\优化数据\';
file = '6_36.dat';
dat3 = importdata([path,file]);
dat1 = change_3to1('tip',dat3);
data = change_1to3(dat1);

function data1 = change_3to1(sec,data3)
    %确定截面位置，加载参考数值
    data1 = data3;
    path = 'D:\Users\ASUS\Desktop\毕业设计工程算例\数据\优化数据\';
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
     for i = 1:6
     boud(i,1) = ref(i)+boud(i,1);
     boud(i,2) = ref(i)+boud(i,2);
     end
     for i=1:6 %6个变量
        data1(:,i) = data3(:,i)*(boud(i,2)- boud(i,1))+ boud(i,1);
     end
end

function data3 = change_1to3(data1)
    data3 = data1;
    path = 'D:\Users\ASUS\Desktop\毕业设计工程算例\数据\优化数据\';
    Ref = importdata([path,'ref_all.dat']);
   
     boud = Ref;
   
     for i=1:6 %6个变量
        data3(:,i) = (data1(:,i)-boud(i,1))/(boud(i,2)- boud(i,1));
     end

end
