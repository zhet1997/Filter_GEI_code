function [x_l,x_h] = GEI(opt,option)
[x] = opt.select_GEI('high');
x_h = opt.cluster(x,option.cluster_h*sqrt(opt.Sample.dimension) );
if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')
    x_l =opt.cluster(x,option.cluster_l*sqrt(opt.Sample.dimension));
elseif  strcmp(option.model,'Kriging')==1
    x_l = [];
else
    error('illeagle input');
end
end