%2019-8-29
function EGO(option)
%% 
if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')==1
    file_name = [option.date,'%',option.func.hi_fi,'&',option.func.low_fi,'&',num2str(option.func.errpara),'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'.mat'];
elseif  strcmp(option.model,'Kriging')==1
    file_name = [option.date,'%',option.func.hi_fi,'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'%',num2str(option.testtime),'.mat'];
else
    error('输入的方法不在可选范围内');
end
%=============================================================
%% initial establish of surrogate
if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')
    sam = Sample('mult',option.func.hi_fi,option.func.low_fi,option.func.errpara,option.initial.num(1),option.initial.num(2));
elseif  strcmp(option.model,'Kriging')==1
    sam = Sample('high',option.func.hi_fi,option.initial.num(1));
else
    error('输入的方法不在可选范围内');
end
mod = GPfamily( sam.points, sam.values , option.model);
opt = Iteration(sam,mod);
%=========================================================
%% iterations
for iteration=1:option.itermax
    %fprintf("这是第%d次迭代\n",iteration);
    [x_l,x_h]=infill(opt,option);
    opt.Update(x_l,x_h);
    opt.record;
    opt.result;

     %if opt.Stop_error(option.stop)==1
         %break;
    % save([option.path,file_name]);
     %end   
    if opt.Stop_source(option.max)==1
        save([option.path,file_name]);
        break;
    end    

end
%==============================================================
%% save data
clear('x_l','x_h','sam','iteration','mod');
save([option.path,file_name]);
disp('alredy save');
end