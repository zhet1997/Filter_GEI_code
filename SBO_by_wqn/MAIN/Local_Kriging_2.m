%2019-5-6
%�������Ϊ�ֲ�kriging_2��������
%�ֲ�kriging_1�������ǣ�1�ֲ���Ӧ��Ĵ�С�ᷢ���仯��
                      %2�ֲ���Ӧ���ʼ���մ��ڣ�
                      %3ֻ��һ���ֲ���Ӧ�棻
                      %4�ֲ���Ӧ��������Ǽӿ�ֲ�������
%Ҫʵ�־ֲ�kriging,����Ҫ��Sample�����һ��ѡ����ܶ����λ�õĺ�����
%����Ҫ��Iteration�����һ��ֻ�Ծֲ�������������ĺ�����
%��û��ܼ�һ����������Ӧ���Ǻϳ̶Ƚ��������ĺ���

clc;clear;
%==========================================================================
%ȡ��ʼ������,��������Ӧ��
    sam = Sample('mult','branin',20,3);
    opts = struct();
    mod = oodacefit( sam.points, sam.values, opts );
    opt = Iteration(sam,mod);
    
    for iteration=1:100
        fprintf("���ǵ�%d�ε���\n",iteration);
        x=opt.select_EI('high');
      
      
       
        
        opt.Update(x,x);
        
 
        opt.record;
        opt.result;
        
    end   