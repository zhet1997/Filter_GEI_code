%2019-5-10
%�˺����������������;�����߾��Ⱥ���֮��������
%�˺����Ĳ�֮ͬ������������ǿɱ仯�ģ��ɵ��ڵ�
%Ŀǰ֮���3�׵�hartmann_3D��5�׵�ackley.
function [y] = Errormodel_dynamic(a,functype,errtype,para)

y = Testmodel(a,functype) + para * Testmodel(a,errtype);

end