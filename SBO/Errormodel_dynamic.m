%2019-5-10
%此函数的作用是描述低精度与高精度函数之间的误差项
%此函数的不同之处在于误差项是可变化的，可调节的
%目前之针对3阶的hartmann_3D和5阶的ackley.
function [y] = Errormodel_dynamic(a,functype,errtype,para)

y = Testmodel(a,functype) + para * Testmodel(a,errtype);

end