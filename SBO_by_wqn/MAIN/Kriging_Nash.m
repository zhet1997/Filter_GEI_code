%2019-7-7
%今天是七七事变82周年纪念日
%勿忘国耻，振兴中华
clc;clear;
 func_name = 'ackley2';
 func_dim = 9;
 xx = mat2cell(1:func_dim,[1],[3,3,3])';
 bp = rand(1,func_dim);
 
 
 for iteration = 1:5
     
 x=cell(size(xx,1),1);
 y=cell(size(xx,1),1);
 for ii = 1:size(xx,1)
    [x{ii},y{ii}] = Nash(func_name,xx{ii,1},bp); 
 end   
 %y = cellfun(@Nash,{func_name},xx,{bp}); 
 
 bp = cell2mat(x');
 record_ymin(iteration) = Testmodel_nash(bp,func_name);
 
 end
 