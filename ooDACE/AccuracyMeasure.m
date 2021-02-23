%2020-12-14
%���ڶԱȺ�����real function ֮������
function [y] = AccuracyMeasure(mod,func,num)
%ACCURACYMEASURE������ֱ��ǣ�ģ�ͣ���ʵ������������
%������Ϣ�ɼ�
sam = mod.getSamples();
inDim = size(sam,2);%ģ�͵�ά��
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

