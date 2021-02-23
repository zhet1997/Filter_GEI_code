%clc;clear
%测试函数名称
func_name ='goldstein_price';
%算法类型
algo_type ='Kriging';
%初始加点
ini_number = 21;
ini_number_l=90;
%加点方法
add_type = 'EI';

a=figure(1);

%title('hartmann3D 函数的Cokriging EI加点不同初始点对比', 'FontSize', 14);
%title('Shekel函数的GEI加点对比', 'FontSize', 14);
%title('Shekel 函数的EI加点不同低精度函数对比', 'FontSize', 14);
%title('branin函数EI方法是否找到最优值区域', 'FontSize', 14);
%title('Ackley函数', 'FontSize', 14);
% xlabel('高精度加点数', 'FontSize', 14);
%xlabel('迭代次数', 'FontSize', 14);
%ylabel('最优样本值', 'FontSize', 14);
 maxiter = 20;%最大迭代数目
 boxdata = zeros(10,maxiter);
for ii=1:10
    path1 = 'E:\ooDACE\DATA\databox_2019_5_21\';
    path2 = [func_name,'\',algo_type,'\'];
    file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(ii),'.mat'];
    load([path1,path2,file_name]);
    
    if opt.Sample.gen>1
        %a = opt.Sample.initial_num_h;
        a=0;
        
        mm = min(opt.Sample.values_h(1:opt.Sample.initial_num_h,:));%计算初始加点后的最小值
        nn = opt.Sample.initial_num_l*0.1+opt.Sample.initial_num_h;%计算初始加点后的折合加点数
        opt.value_min_record=[mm,opt.value_min_record];%加在前面
        opt.cost_record = [nn,opt.cost_record];%加在前面
        
       
       %for j=1:min(size(opt.corr1_record,2),maxiter)
%        for j=1:maxiter
%            if j>size(opt.corr1_record,2)
%             boxdata(ii,j)=opt.corr1_record(end);
%            else
%             boxdata(ii,j)=opt.corr1_record(j);
%            end
%         end

       for j=1:maxiter
           if j>size(opt.value_min_record,2)
            boxdata(ii,j)=0;
           else
            boxdata(ii,j)=opt.value_min_record(j);
           end
        end

     end
    
end


 boxplot(boxdata)%,'color','r');
xlabel('迭代次数', 'FontSize', 14);
ylabel('最优样本值', 'FontSize', 14);
%axis([0 21 -0.1 1])
set(gca,'FontSize',12);
box off
