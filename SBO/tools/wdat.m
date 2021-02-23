function  wdat(matrix,file,type)
%WDAT 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin==2
type = 'wt';
end
fid=fopen(file,type);%写入文件路径
[m,n]=size(matrix);
if isa(matrix,'cell')==1
    for i=1:1:m
        for j=1:1:n
            if j==n
                fprintf(fid,'%s\n',num2str(matrix{i,j}));
            else
                fprintf(fid,'%s\t',num2str(matrix{i,j}));
            end
        end
    end
else
    for i=1:1:m
        for j=1:1:n
            if j==n
                fprintf(fid,'%g\n',matrix(i,j));
            else
                fprintf(fid,'%g\t',matrix(i,j));
            end
        end
    end
end
fclose(fid);
end

