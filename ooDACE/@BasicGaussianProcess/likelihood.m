%> @file "@BasicGaussianProcess/likelihood.m"
%> @authors Ivo Couckuyt
%> @version 1.4 ($Revision$)
%> @date $LastChangedDate$
%> @date Copyright 2010-2013
%>
%> This file is part of the ooDACE toolbox
%> and you can redistribute it and/or modify it under the terms of the
%> GNU Affero General Public License version 3 as published by the
%> Free Software Foundation.  With the additional provision that a commercial
%> license must be purchased if the ooDACE toolbox is used, modified, or extended
%> in a commercial setting. For details see the included LICENSE.txt file.
%> When referring to the ooDACE toolbox please make reference to the corresponding
%> publications:
%>   - Blind Kriging: Implementation and performance analysis
%>     I. Couckuyt, A. Forrester, D. Gorissen, F. De Turck, T. Dhaene,
%>     Advances in Engineering Software,
%>     Vol. 49, pp. 1-13, July 2012.
%>   - Surrogate-based infill optimization applied to electromagnetic problems
%>     I. Couckuyt, F. Declercq, T. Dhaene, H. Rogier, L. Knockaert,
%>     International Journal of RF and Microwave Computer-Aided Engineering (RFMiCAE),
%>     Special Issue on Advances in Design Optimization of Microwave/RF Circuits and Systems,
%>     Vol. 20, No. 5, pp. 492-501, September 2010. 
%>
%> Contact : ivo.couckuyt@ugent.be - http://sumo.intec.ugent.be/?q=ooDACE
%> Signature
%>	[out dout] = likelihood( this, F, hp )
%
% ======================================================================
%> Used for Maximum Likelihood Estimation (MLE).
%> First the model is updated, then one of the following loss functions is calculated
%> - marginal likelihood
%> - pseudo-likelihood (~cross validation)
%>
%> See:
%> - "Gaussian Processes for Machine Learning" (Chapter 5),
%> C. E. Rasmussen and C. K. I. Williams,
%> MIT Press, 2006
% ======================================================================
function [out,dout] = likelihood( this, F, hp )%最大似然函数，hp是一组具体的超参数
%这个函数基本就是一个整合其他函数的空壳，这些内容完全可以写在主函数里。

    param = {this.options.rho0 this.options.lambda0 this.options.sigma20 this.hyperparameters0};
    if isa(this,'HighDimensionKriging')&&~isempty(this.indexRatio)
        param(1,this.optimIdx) = mat2cell( hp, 1, size(cell2mat(this.indexRatio),2) );
    else
        param(1,this.optimIdx) = mat2cell( hp, 1, this.optimNrParameters );
    end
    %这里需要非常注意，因为在定比例的情况下this.optimNrParameters会不等于优化的维度。
	%% correlation
	[this ,err ,dpsi] = this.updateStochasticProcess( param );%为什么这里就有一个对于随机过程模型的更新？？
	%这里的dpsi是什么？？？
    if ~isempty(err)%如果有报错，就输出无限大
		out = +Inf;
		dout = zeros( 1, size( hp, 2 ) );
		return;
	end
	
	%% regression (get least squares solution)
	[this, err, dsigma2] = this.updateRegression( F, param );%为什么这里就有一个对于回归模型的更新？？
	if ~isempty(err)%如果有报错，就输出无限大
		out = +Inf;
		dout = zeros( 1, size( hyperparameters, 2 ) );
		return;
	end

    %% likelihood
    if nargout > 1
        [out, dout] = this.options.hpLikelihood( this, dpsi, dsigma2 );%这个对象的内容为@marginalLikelihood%小的%边缘的
    else
        out = this.options.hpLikelihood( this );
    end
end
