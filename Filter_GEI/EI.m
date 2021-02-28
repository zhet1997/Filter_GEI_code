function [x_l,x_h] = EI(opt,option)
[x_h] = opt.select_EI('high');
if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')
    x_l = x_h;
elseif  strcmp(option.model,'Kriging')==1
    x_l = [];
else
    error('illeagle input');
end
end