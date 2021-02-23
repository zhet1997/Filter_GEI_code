function data1 = changeto(sec,data3)
    %确定截面位置，加载参考数值
    data1 = data3;
     path =  'D:\Users\ASUS\Desktop\迁移学习算例\';
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
     for i=1:7 %6个变量
        data1(:,i) = data3(:,i)*(boud(i,2)- boud(i,1))+ boud(i,1);
     end
end