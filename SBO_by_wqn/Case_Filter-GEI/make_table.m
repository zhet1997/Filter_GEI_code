clc;clear;
txt = importdata('D:\Users\ASUS\Desktop\data.txt');
data = txt.data;
for jj=1:30
for kk = [1,3,4]
   % data(jj,kk) = round(data(jj,kk));
    data(jj,kk) = ceil(data(jj,kk));
end

for kk = [5,7,8]
    %data(jj,kk) = roundn(data(jj,kk),0);
    data(jj,kk) = ceil(data(jj,kk));
end

for kk = [2,6]
    data(jj,kk) = roundn(data(jj,kk),-4);
end
end
result_av=data(:,1:4);
result_std = data(:,5:8);

for ii=1:30
box = cell(1,5);
    for kk=1:4
    temp = ['$',num2str(result_av(ii,kk)),'\pm',num2str(result_std(ii,kk)),'$'];
    box{1,kk} = temp;
    end
    box{1,5}=[num2str(data(ii,9)),'/20'];
%    box = [result_av,result_std];
%    box = mat2cell(box,linspace(1,1,size(box,1)),linspace(1,1,size(box,2)));
%     box = [name_record{1,1},name_record{1,2},box,{sample_num_initial},{times_all}];
    box = [txt.textdata{ii,1},txt.textdata{ii,2},box];
    xlswrite(['D:\Users\ASUS\Desktop\result.xlsx'],box,4,['A',num2str(ii)]);
end