%1forrester
%2branin   y_min=0.397887 at(-pi,12.275);(pi,2.275);(9.42478,2.475)
%3hartmann_3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at（4,4,4,4）
%6goldstein_price   y_min=3  at(0,-1);
%7hartmann_6D  y_min=-3.32237 at(0.20169,0.150011,0.476874,0.275332,0.311652,0.6573)
%数据采集模板

%2019-9-21
%本程序为测试的模板程序，适用于不同算法与不同测试函数搭配的情况
%包含如下部分：
%1.测试函数选取
%2.优化算法选取
%3.算法参数给定
%4.优化过程与结果储存
function index_in(inPut,outPutPath)
option = struct();
%对参数进行设置
option.path = [outPutPath,'result\'];
%====================================
option.date = datestr(datetime('today')+2,'yyyy-mm-dd');
%====================================
option.func.hi_fi = inPut{1};
option.func.low_fi = inPut{2};
option.func.errpara = inPut{3};
%====================================
option.initial.num = [inPut{4},inPut{5}];
option.model = inPut{6};
%'Filter_GEI'=='EI'== 'augmented_EI'=='VF-EI'=='GEI';
option.infill = inPut{7};
option.stop = inPut{8};
option.max = inPut{9};
%====================================
option.itermax = inPut{10};
option.cluster_h = inPut{11};
option.cluster_l = inPut{12};
option.testtime = 1;

if strcmp(option.model,'CoKriging')==1||strcmp(option.model,'HierarchicalKriging')==1
file_name = [option.date,'%',option.func.hi_fi,'&',option.func.low_fi,'&',num2str(option.func.errpara),'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'.mat'];
elseif  strcmp(option.model,'Kriging')==1
file_name = [option.date,'%',option.func.hi_fi,'%',option.model,'%',option.infill,'%',num2str(option.initial.num(end)),'%',num2str(option.testtime),'.mat'];
else
error('输入的方法不在可选范围内');
end

save([outPutPath,file_name],'option');
disp('alredy save');