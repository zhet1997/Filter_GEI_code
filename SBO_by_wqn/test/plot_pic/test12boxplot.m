%clc;clear
%���Ժ�������
func_name ='goldstein_price';
%�㷨����
algo_type ='Kriging';
%��ʼ�ӵ�
ini_number = 21;
ini_number_l=90;
%�ӵ㷽��
add_type = 'EI';

a=figure(1);

%title('hartmann3D ������Cokriging EI�ӵ㲻ͬ��ʼ��Ա�', 'FontSize', 14);
%title('Shekel������GEI�ӵ�Ա�', 'FontSize', 14);
%title('Shekel ������EI�ӵ㲻ͬ�;��Ⱥ����Ա�', 'FontSize', 14);
%title('branin����EI�����Ƿ��ҵ�����ֵ����', 'FontSize', 14);
%title('Ackley����', 'FontSize', 14);
% xlabel('�߾��ȼӵ���', 'FontSize', 14);
%xlabel('��������', 'FontSize', 14);
%ylabel('��������ֵ', 'FontSize', 14);
 maxiter = 20;%��������Ŀ
 boxdata = zeros(10,maxiter);
for ii=1:10
    path1 = 'E:\ooDACE\DATA\databox_2019_5_21\';
    path2 = [func_name,'\',algo_type,'\'];
    file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(ii),'.mat'];
    load([path1,path2,file_name]);
    
    if opt.Sample.gen>1
        %a = opt.Sample.initial_num_h;
        a=0;
        
        mm = min(opt.Sample.values_h(1:opt.Sample.initial_num_h,:));%�����ʼ�ӵ�����Сֵ
        nn = opt.Sample.initial_num_l*0.1+opt.Sample.initial_num_h;%�����ʼ�ӵ����ۺϼӵ���
        opt.value_min_record=[mm,opt.value_min_record];%����ǰ��
        opt.cost_record = [nn,opt.cost_record];%����ǰ��
        
       
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
xlabel('��������', 'FontSize', 14);
ylabel('��������ֵ', 'FontSize', 14);
%axis([0 21 -0.1 1])
set(gca,'FontSize',12);
box off
