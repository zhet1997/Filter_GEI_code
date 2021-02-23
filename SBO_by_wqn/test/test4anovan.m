clc;clear;
path = 'D:\Users\ASUS\Desktop\优化算例2019_6_14\结果分析\result\';
file0 = 'points.dat';
file1 = 'eloss1.dat';
file2 = 'eloss2.dat';
file3 = 'eloss3.dat';
file4 = 'eloss4.dat';
file5 = 'eloss5.dat';
dat0 = importdata([path,file0]);
dat1 = importdata([path,file1]);
dat2 = importdata([path,file2]);
dat3 = importdata([path,file3]);
dat4 = importdata([path,file4]);
dat5 = importdata([path,file5]);

data = [dat1,dat2,dat3,dat4,dat5];

sam = Sample('high','E3',0);
sam.put_in('all_h',[dat0,dat1]);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);


result = zeros(11,100);
number = 10000;
points = lhsdesign(number,opt.Sample.dimension);
gridy1 = zeros(number,1);%原模型序列
for k= 1:1
    for i=1:100
        x = i/100;
        points_now = points;
        points_now(:,k) = linspace(x,x,number);
        for j=1:number
            gridy1(j) = opt.Model.predict(points_now(j,:));
        end
        result(k,i) =sum(gridy1)/number;
    end
end









