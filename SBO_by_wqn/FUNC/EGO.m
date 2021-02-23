%2019-8-29
function EGO(option)
%% ���ݱ�������
if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')==1
    file_name = [option.date,'%',option.func.hi_fi,'&',option.func.low_fi,'&',num2str(option.func.errpara),'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'.mat'];
elseif  strcmp(option.model,'Kriging')==1
    file_name = [option.date,'%',option.func.hi_fi,'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'%',num2str(option.testtime),'.mat'];
else
    error('����ķ������ڿ�ѡ��Χ��');
end
%=============================================================
%% ������ʼģ��
if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')
    sam = Sample('mult',option.func.hi_fi,option.func.low_fi,option.func.errpara,option.initial.num(1),option.initial.num(2));
elseif  strcmp(option.model,'Kriging')==1
    sam = Sample('high',option.func.hi_fi,option.initial.num(1));
else
    error('����ķ������ڿ�ѡ��Χ��');
end
mod = krigingfamily( sam.points, sam.values , option.model);
opt = Iteration(sam,mod);
%=========================================================
%% ��ʼ��������
for iteration=1:option.itermax*2%�޸�
    %fprintf("���ǵ�%d�ε���\n",iteration);
    [x_l,x_h]=infill(opt,option);%ѡ��ӵ�λ��
    opt.Update(x_l,x_h); %����ģ��
    opt.record;%��¼ģ��
    opt.result;%�����ǰ���
    % �ж��Ƿ�����
     %if opt.Stop_error(option.stop)==1
         %break;
    % save([option.path,file_name]);
     %end   
    if opt.Stop_source(option.max)==1
        save([option.path,file_name]);
        break;
    end    
%     if opt.Stop_sla()==1
%         break;
%     end
end
%==============================================================
%% ��������
clear('x_l','x_h','sam','iteration','mod');
save([option.path,file_name]);
disp('alredy save');
end