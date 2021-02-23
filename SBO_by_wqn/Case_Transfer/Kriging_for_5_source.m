%2019-10-25
%��һ������Ŀ����̽����ʼ�����ֲ��仯�Դ���ģ����ɵ�Ӱ�졣
%��GE-E3��һ����Ҷ�м�����ڲ�ͬ����������µ�������ʧϵ����Ӧ������Ϊ���Ժ���

%������0.6��Ӧ����Ϊ�߾�����Ӧ��
%�ֱ������������Ӧ����Ϊ�;�����Ӧ��

%��ʼ�ӵ�����Ϊ30���ӵ㷽ʽΪ�Ż�LHS
%��ǰ׼��10��LHS���ݱ���
%����20��
%==========================================================================
clc;clear;
%��ȡ�봢��·��
path1 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\surf\';%��Ӧ��������Դ
path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\';%��ʼ����λ��
path3 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\completed_task\';%�������λ��
%����ѡ��

for func = [0.7,0.8,0.9,1.0,1.1] 
 sample50 = cell(1,10);
for time = 1:10
    
inform.func=func;
inform.time = time;

%������Ӧ��mat�ļ�
load([path1,'res_surf',num2str(func),'.mat'],'mod');
fun_h = mod;
clear('mod');
%����LHS�ֲ��ļ�
load([path2,'sample30.mat']);
%��ʼ����
points = ini_sample_box{1,time};
values = fun_h.predict(points);
%������ʼ��Ӧ�棬�����ʼ��Ӧ�澫��
%������
sam = Sample('high','E3',0);
sam.put_in('all_h',[points,values]);
mod = krigingfamily( sam.points, sam.values,'Kriging');
%mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

%��ʼEI����20��
for iteration=1:20
%    fprintf("���ǵ�%d�ε���\n",iteration);
    [x1] = opt.select_EI('high');
    y1 = fun_h.predict(x1);
    opt.Update([x1,y1]);
    opt.record;
    opt.result; 
    
%     if opt.best_value<=0.0353
%          break;
%      end
    
end

%������
save([path3,num2str(inform.func),'_',num2str(time),'.mat'],'opt','inform');
sample50{1,time} = opt.Sample.points_h;
end
save([path2,'sample/',num2str(inform.func),'.mat'],'sample50');
end







