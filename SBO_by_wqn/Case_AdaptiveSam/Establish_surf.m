%2020-4-2
%建立响应面作为低精度源
clc;clear;
%% 输入数据
surf125 = importdata('D:/Users/ASUS/Desktop/Engineering_Case_20200325/iter250_0.5.dat');
surf200 = importdata('D:/Users/ASUS/Desktop/Engineering_Case_20200325/iter200.dat');
surf500 = importdata('D:/Users/ASUS/Desktop/Engineering_Case_20200325/iter500.dat');
surf250 = importdata('D:/Users/ASUS/Desktop/Engineering_Case_20200325/iter500_0.5.dat');
surf1000 = importdata('D:/Users/ASUS/Desktop/Engineering_Case_20200325/iter1000.dat');
point_150 = importdata('D:/Users/ASUS/Desktop/Engineering_Case_20200325/points_150.dat');

sam = Sample('high','E3',0);
sam.put_in('all_h',[point_150,surf125]);
mod = krigingfamily( sam.points, sam.values,'Kriging');
opt = Iteration(sam,mod);   

%plot(1:150,[surf125,surf500,surf1000]')
%plot(1:150,[surf250,surf1000]')

%save('D:/Users/ASUS/Desktop/Engineering_Case_20200325/surf_low.mat','mod');