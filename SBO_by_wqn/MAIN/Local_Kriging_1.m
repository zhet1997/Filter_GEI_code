%2019-5-6
%�������Ϊ�ֲ�kriging_1��������
%�ֲ�kriging_1�������ǣ�1�ֲ���Ӧ��Ĵ�С�������仯��
                      %2�ֲ���Ӧ����һ����������֮��ų���
                      %3����ͬʱ���ڶ���ֲ���Ӧ��
                      %4�ֲ���Ӧ��������Ǽӿ�ֲ�����
%Ҫʵ�־ֲ�kriging,����Ҫ��Sample�����һ��ѡ����ܶ����λ�õĺ�����
%����Ҫ��Iteration�����һ��ֻ�Ծֲ�������������ĺ�����
%��û��ܼ�һ����������Ӧ���Ǻϳ̶Ƚ��������ĺ���

clc;clear;
%==========================================================================
%ȡ��ʼ������,��������Ӧ��
for test_time = 2:1:5
    sam = Sample('mult','hartmann_3D',18,9);
    mod = oodacefit( sam.points, sam.values, struct());
    opt = Iteration(sam,mod);
    
    for iteration=1:50
        fprintf("���ǵ�%d�ε���\n",iteration);
        x=opt.select_EI('high');   
        opt.Update(x,x);
        opt.record;
        opt.result;
%         if opt.Sample.start_local==1
%             break;
%         end
         if opt.Stop_error==1%��������
            break;
        end
    end  
    
    

     algo_type ='CoKriging';
     func_name = 'hartmann_3D';
      add_type = 'EI';
                %��ʼ�ӵ�
                ini_number = 9;
               % ini_number_l=99;
                %�ӵ㷽��

 path1 = 'E:\ooDACE\Append_by_wqn\databox_2019_5_10\';
 path2 = [func_name,'\',algo_type,'\'];
 file_name = [func_name,'_',algo_type,'_',add_type,'_','ini',num2str(ini_number),'_',num2str(test_time),'.mat'];
            save([path1,path2,file_name]);
            disp('alredy save');
end