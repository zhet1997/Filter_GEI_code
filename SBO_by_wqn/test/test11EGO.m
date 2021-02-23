clc;clear;

path1 = 'E:\dataset_20190829\option_bag7\';
a = dir( 'E:\dataset_20190829\option_bag7\*.mat');
for ii = 1:length(a)
    c{ii,:} = a(ii).name;
    %c{ii,:} = strrep(c{ii,:},'.mat','');
end

for ii=1:15
    
    for jj = 1:length(a)
        try
            load([path1,c{jj,:}],'option')
            option.testtime = ii;
            EGO(option);
        catch
            
        end
        
    end
    
end



