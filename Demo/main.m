clc;clear;
index('index_file.xlsx')
disp('option files are already saved.')

optionList = dir(fullfile('.\Demo\','*.mat')) ;

for ii = 4:5
load(['.\Demo\',optionList(ii).name]);
EGO(option)
end