clc;clear

%测试函数名称
func_name ='ackley';
%算法类型
algo_type ='CoKriging';
%初始加点
ini_number =15;
%ini_number_l=90;
%加点方法
%add_type = 'VF_EI';
%add_type = 'new';
%add_type = 'augmented_EI';
add_type = 'Filter_GEI';

gen_av = 0;
add_av = 0;
add_av_l =0;
val_av = 0;
error_av=0;
ei=0;
ia=0;

for draw=1:10
    
path1 = 'E:\ooDACE\DATA\databox_2019_8_21\';
%path2 = [func_name,'\',algo_type,'\'];
path2 = [func_name,'\',algo_type,'\'];
file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(draw),'.mat'];
load([path1,path2,file_name]);%对应文件已载入
%opt.result;

if opt.Sample.gen>1
    ia=ia+1;
%计算平均迭代次数

gen_av  = gen_av + opt.Sample.gen;
%计算平均加点个数
add_av = add_av + opt.Sample.number_h;

add_av_l = add_av_l + opt.Sample.number_l;

%计算平均最优值

val_av  = val_av + opt.best_value;

%计算pj最优值误差
error_av = error_av + opt.error_value;

%计算EI收敛比例
%if strcmp(opt.jump_out,'EI')
% if opt.EI_max_record(opt.Sample.gen)<1e-4
%     ei = ei+1;
% end

end
end

gen_av =gen_av/ia;
 fprintf("迭代次数是%f\n",gen_av);
add_av = add_av/ia;
 fprintf("高精度加点是%f\n",add_av-ini_number);
add_av_l= add_av_l/ia;
 fprintf("低精度加点是%f\n",add_av_l-ini_number*2);
val_av = val_av/ia;
 fprintf("最优值是%f\n",val_av);
error_av=error_av/ia;
 fprintf("误差是%f\n",error_av);




