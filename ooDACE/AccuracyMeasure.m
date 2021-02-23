%2020-12-14
%用于对比函数和real function 之间的误差
function [y] = AccuracyMeasure(mod,func,num)
%ACCURACYMEASURE的输入分别是：模型，真实函数，采样数
%基本信息采集
sam = mod.getSamples();
inDim = size(sam,2);%模型的维度
design = lhsdesign(num,inDim);

val = func(design);
PredictY = mod.predict(design);


Error = val - PredictY;
NorError = Error./val;
RMSE = sqrt(Error'*Error/num);
NRMSE = sqrt(NorError'*NorError/num);
R2 = 1 - (Error'*Error/num)/(std(val)^2);

y.Y = val;
y.PredictY = PredictY;
y.RMSE = RMSE;
y.NRMSE = NRMSE;
y.R2 = R2;
end

