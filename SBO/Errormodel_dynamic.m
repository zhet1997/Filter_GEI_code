function [y] = Errormodel_dynamic(a,functype,errtype,para)

y = Testmodel(a,functype) + para * Testmodel(a,errtype);

end