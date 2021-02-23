clc;clear;
databox = [];
num_box = [];
iter = 21;
for case_i = 1:15

path_save = ['D:/Users/ASUS/Desktop/Case_20200619/Case_',num2str(case_i),'/Points/'];
filename_h = ['iter',num2str(iter+1),'_h.dat'];
p_h = importdata([path_save,filename_h]);
num_box = [num_box; size(p_h,1)];
databox = [databox;p_h];
end
num_box = cumsum(num_box);