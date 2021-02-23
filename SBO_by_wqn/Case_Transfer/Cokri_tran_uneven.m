%2019-10-25
%�о�һ�¸ߵ;���ģ�������Ժ���������Cokriging����ģ�;��ȵ�Ӱ��
%��GE-E3��һ����Ҷ�м�����ڲ�ͬ����������µ�������ʧϵ����Ӧ������Ϊ���Ժ���

%������0.6��Ӧ����Ϊ�߾�����Ӧ��
%�ֱ������������Ӧ����Ϊ�;�����Ӧ��

%�;��ȳ�ʼ�ӵ�����Ϊ50���ӵ㷽ʽΪLHS
%��ǰ׼��10��LHS���ݱ���
%�߾��ȳ�ʼ�ӵ���Ϊ 5 10 20 30 40���ӵ㷽ʽ������

%��ÿ�ֳ�ʼ�ӵ�״̬�������ģ����Ӧ�澫��

%��ÿ�ֳ�ʼ�ӵ�״̬����20������¼��������
%==========================================================================
clc;clear;
%��ȡ�봢��·��
path1 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\surf\';
path2 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\sample\';
path3 = 'D:\Users\ASUS\Desktop\Ǩ��ѧϰ����20191025\result\';
%����ѡ��

for lowfunc = [0.7,0.8,0.9,1.0,1.1]
    
for number = [5,10,20,30,40]
    
 addtype = 2;%��ѡ��һ�ֳ�ʼ�ӵ㷽ʽ
for time = 1:10
    
inform.lowfunc=lowfunc;
inform.number=number;
inform.addtype=addtype;
inform.time = time;

%���ظߵ;�����Ӧ��mat�ļ�
load([path1,'res_surf',num2str(0.6),'.mat'],'mod');
fun_h = mod;
load([path1,'res_surf',num2str(lowfunc),'.mat'],'mod');

fun_l = mod;
clear('mod');
%����LHS�ֲ��ļ�
load([path2,num2str(lowfunc),'.mat']);
%�;��Ȳ���
points_l = sample50{1,time};
values_l = fun_l.predict(points_l);
%ѡ��߾��Ȳ�����ʽ���и߾��Ȳ���
points_h = cluster(points_l,values_l,addtype,number);
values_h = fun_h.predict(points_h);
%������ʼ��Ӧ�棬�����ʼ��Ӧ�澫��
%������
if addtype==0&&lowfunc==0.7
sam = Sample('high','E3',0);
sam.put_in('all_h',[points_h,values_h]);
mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);
inform.lowfunc=0;
elseif addtype==0&&lowfunc~=0.7
    continue%��������ѭ��
else
sam = Sample('high','E3',0);

sam.initial_num_l = 50;
sam.number_l = 0;
sam.samtype = 'mult';

sam.put_in('all_h',[points_h,values_h]);
sam.put_in('all_l',[points_l,values_l]);
%mod = oodacefit( sam.points, sam.values, struct());
mod = krigingfamily( sam.points, sam.values,'CoKriging');
opt = Iteration(sam,mod);
end
%��ʼEI������
for iteration=1:50
%    fprintf("���ǵ�%d�ε���\n",iteration);
    [x1] = opt.select_EI('high');
    y1 = fun_h.predict(x1);
    opt.Update([x1,y1]);
    opt.record;
    opt.result; 
    
    if opt.best_value<=0.0353
         break;
     end
    
end
%������
save([path3,num2str(inform.lowfunc),'_',num2str(number),'_',num2str(addtype),'_',num2str(time),'.mat'],'opt','inform')


end
end
end








function [y] = cluster(points_l,values_l,addtype,number)

points_h = points_l;
values_h = values_l;

for i=1:50-number
    
    %==================================================
    y = pdist(points_h,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%������ӽ���������֮һ
    p2 = z(1,2);%������ӽ���������֮һ
    d1 = sum((points_h(p1,:) - linspace(0.5,0.5,3)).^2);
    d2 = sum((points_h(p2,:) - linspace(0.5,0.5,3)).^2);
  switch addtype 
      case {1,0}
     if d1>d2%ѡ��������Ľ�����һ��ȥ��
         p = p2;
     else
         p = p1;
     end
    
      case 2

    if values_h(p1)<= values_h(p2)%ѡ��tipֵ�����һ��ȥ��
        p = p2;
    else
        p = p1;
    end
     
    %====================================================
      case 3
    p=find(values_h==max(values_h));%�ҵ�����һ��
    p=p(1);%�����ж����ֻ����һ��
    
  end

    values_h(p,:)=[];
    points_h(p,:) = [];%ȥ����p����
end

y = points_h; 
end