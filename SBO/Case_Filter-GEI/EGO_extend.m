%2020-5-20
%�ó������ʹ�ü���������Ż������ӳ����㡣
function EGO_extend(option,result_old)
%���س�ʼģ��
opt = result_old;
%=======================================================
%��������ļ���
% if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')==1
%     file_name = [option.date,'%',option.func.hi_fi,'&',option.func.low_fi,'&',num2str(option.func.errpara),'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'.mat'];
% elseif  strcmp(option.model,'Kriging')==1
%     file_name = [option.date,'%',option.func.hi_fi,'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'%',num2str(option.testtime),'.mat'];
% else
%     error('����ķ������ڿ�ѡ��Χ��');
% end
file_name = option.filename;
%=================================================================
for iteration=1:1%�޸�
    %fprintf("���ǵ�%d�ε���\n",iteration);
    [x_l,x_h]= infill(opt,option);
    opt.Update(x_l,x_h);
    
    
    opt.record;
    opt.result;
    
%       if opt.Stop_error(option.stop)==1
%           %break;
%           save([option.path,file_name]);
%       end
%     
%     if opt.Stop_source(option.max)==1
%         break;
%     end
    
%     if opt.Stop_sla()==1
%         break;
%     end
end

clear('x_l','x_h','sam','iteration','mod');
save([option.path,file_name]);
disp('alredy save');
end