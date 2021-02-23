%> @file "oodacefit.m"
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
%>	k = oodacefit( samples, values, userOpts )
%
% ======================================================================
%> @brief  Creates and fits a kriging model with sensible options
%>
%>	For easy fitting when you don't care much about parameters.
%>	The function tries to determine the best kriging model to use:
%>	- samples is numeric array -> kriging
%>	- samples is cell array -> cokriging
%>
%> @param samples input sample matrix
%> @param values output value matrix
%> @param userOpts struct of user options (optional)
%> - userOpts.type overrides the type of kriging model to use, e.g., "BasicGaussianProcess", "Kriging", "CoKriging", etc.
%> - For regression kriging set the following fields:
%>   - userOpts.lambda0 = 0;
%>   - userOpts.lambdaBounds = [-5 ; 5]; % log scale
%> - For stochastic kriging set the following fields:
%>   - userOpts.Sigma = SigmaVector; % variance of the output values
%>   - userOpts.sigma20 = 1;
%>   - userOpts.sigma2Bounds = [0.001 ; 150];
%> - Please see the BasicGaussianProcess::getDefaultOptions(), Kriging::getDefaultOptions(), etc. methods for more options.
%> @retval k a ready-to-use kriging model
% ======================================================================
function k = oodacefit( samples, values, userOpts )

% Check if the toolbox path has been set
if ~exist('mergeStruct.m','file')
    disp('It seems the ooDACE Toolbox path has not yet been setup, running startup now..')
    startup;
end

if iscell( samples )%判断是kriging或者cokriging
    [n, inDim] = size(samples{1});
else
    [n ,inDim] = size(samples);
end

if exist( 'userOpts', 'var' ) && isfield( userOpts, 'type' )
    type = userOpts.type;
elseif iscell( samples )
    type = 'CoKriging'; % override type
    %type = 'HierarchicalKriging';
else
    type = 'Kriging';
end

opts = eval( [type '.getDefaultOptions()'] );%把字符串当作命令执行
%生成默认格式的模型
opts.type = type;

% Default correlation function and default initial hyperparameter values + bounds
opts.corrFunc = @corrgauss;
opts.hp0 = repmat(0.5, 1, inDim);
opts.hpBounds = [repmat(-2, 1, inDim) ; repmat(2, 1, inDim)];%对下限做一下修改
%opts.hpBounds = [-2,-1.8,-1.5;2,2,2];
%这两项应该是超参数起始位置和超参数边界
%在ooDace中超参数都是以对数的形式保存的，所以起始数为3.16，为什么不是0？

% Default regression function
opts.regrFunc = 'regpoly0';%这一行规定了回归模型，我个人喜欢ordinary kriging

% merge user options if supplied
if exist( 'userOpts', 'var' )
   opts = mergeStruct( opts, userOpts );
end

% build and fit Kriging object
k = feval( opts.type, opts, opts.hp0, opts.regrFunc, opts.corrFunc);%第一个参数可以是函数的句柄或者字符串形式的名称
%在Cokriging类的建立中用到了：hp0？？0.5？？，regrFunc回归模型，corrFunc相关系数方程
k = k.fit( samples, values );

% using the wrapper scripts fitting and evaluating the kriging model would be:
% krige = dacefit(samples, values, 'regpoly0', 'corrgauss', theta0, lb, ub )
% [y, dy, mse, dmse] = predictor([1 2], krige)

end
