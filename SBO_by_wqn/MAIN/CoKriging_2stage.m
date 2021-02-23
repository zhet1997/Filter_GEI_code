%clc;clear;

%首先构造低精度函数优化过程
% sam1 = Sample('low','shekel',100);
% opts1 = struct();
% mod1 = oodacefit( sam1.points, sam1.values, opts1 );
% opt1 = Iteration(sam1,mod1);
% for iteration=1:100
%     fprintf("这是第%d次迭代\n",iteration);
%     
%     
%     x=opt1.select_GEI();
%     
%     
%     opt1.Update(x);
%     opt1.record;
%      %opt1.result;
%     
%     if opt1.Stop_EImax==1%跳出方法
%         break;
%     end
%     if opt1.Stop_sla==1
%         break;
%     end
%     
%     
% end
% opt1.report;

%开始聚类和筛选
a=sam1.values_l;
ax=sam1.points_l;
b=[];
bx=[];
while(isempty(a)==0)
p = find(a==min(a));
c=[10];
for j=1:size(b,1)
    
    c(j)=sqrt(sum((bx(j,:)-ax(p,:)).^2)/4);
end
if min(c)>0.1

bx =[bx; ax(p,:)];
b =[b; a(p,:)];
a(p,:) = [];
ax(p,:) = [];

else
    a(p,:)=[];
    ax(p,:) = [];

end
end



%=======================================================================
sam = Sample('high','shekel',10);
sam.put_in('low',bx)
%sam.put_in('low',bx(1:20,:))


%sam.put_in('high_from_low',20)


opts = struct();
mod = oodacefit( sam.points, sam.values, opts );
opt = Iteration(sam,mod);


for iteration=1:100
    fprintf("这是第%d次迭代\n",iteration);
    
   
        x=opt.select_EI();

   
        opt.Update(x,x);
 
    
    
    opt.record;
    opt.result;
    
    if opt.Stop_EImax==1%跳出方法
        break;
    end
    if opt.Stop_sla==1
        break;
    end
    
    
end
opt.report;






















