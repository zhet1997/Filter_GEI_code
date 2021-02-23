clc;clear;
sam = Sample('high','forrester',10);
func = @(x) 1;
mod = krigingfamily( sam.points, sam.values , 'GeneralizedKriging',func);
%mod = krigingfamily( sam.points, sam.values , 'Kriging');