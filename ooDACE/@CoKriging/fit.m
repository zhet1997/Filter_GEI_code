%> @file "@CoKriging/fit.m"
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
%>	this = fit( this, samples, values )
%
% ======================================================================
%> Need to be invoked before calling any of the prediction methods.
%>	
%> samples/values are (columnwise!) cell arrays.
%> {1} is cheap data ... more expensive ... {end} is most expensive
%> NOTE: though only 2 datasets are supported atm (length of samples/values must be 2)
% ======================================================================
function this = fit( this, samples, values )

% process data for underlying Kriging class
this = this.setData( samples, values );
%this.setData( samples, values );
%% useful constants
t = length(samples);%samples是一个元胞数组，t就代表精度的重数。

% check if this a refit and if a dataset hasn't been changed
%> @note Allow to update the CoKriging model with new data:
%> - this means no scaling as the scaling changes when new data arrives (we
%> inherit from BasicGaussianProcess)
%> - no refitting with the same hyperparameters (no xval calculation)
if ~isempty( this.GP ) %如果已经算了一些，就继续计算
     start = 1;
    %all函数的作用是判断一个矩阵中的数字是否全部不为0；
    while start <= length(this.GP) && ...
           all( size(this.getSamplesIdx(start)) == size(this.GP{start}.getSamples()) ) && ...
           all( all( this.getSamplesIdx(start) ==  this.GP{start}.getSamples() ) )
        start = start + 1;
    end
else
    start = 1;
    
    this.GP = cell(t,1);
    this.rho = cell(t-1,1);
end

%% determine parameters for each dataset%确定每一个精度的数组的超参数
for i=start:t
    samples{i} = this.getSamplesIdx(i);
    values{i} = this.getValuesIdx(i);
    %options是用来储存模型建立多个选项的结构体，这里将其独立出来，使之与this.options可以有所不同
    %即作为低精度或
    options = this.options;
    
    % use the right Optimizer for this sub-GP (if multiple are given)
    if iscell( options.hpOptimizer )
        options.hpOptimizer = options.hpOptimizer{i};
    end
    
    if i == 1 %在计算第一层时rho不存在，变差d就是value
        options.rho0 = -Inf; % disable rho MLE estimation for the first (i==1) sub-GP
        d = values{i};
    else
        % rho
        yc = this.GP{i-1}.predict( samples{i} ); % yc unscaled
        d = [values{i} yc]; % note: watch scaling of both entries!
        
        % rho is predicted by the likelihood of the second sub-GP
        % another possible solution is to use least squares, but this gives bad results
        % this.rho{i-1} = abs(yc) \ abs(values{i});
        % d = values{i} - this.rho{i-1} .* yc;
    end
    
    %创建低精度的响应面，或计算变差的响应面
    this.GP{i} = BasicGaussianProcess(options, this.hyperparameters0, this.regressionFcn, this.correlationFcn);
    this.GP{i} = this.GP{i}.fit(samples{i}, d);%这里的d不是相减后的结果，而是两列都在。%这是因为rho也是优化的参数之一
    
    if i > 1
        this.rho{i-1} = this.GP{i}.getRho();
    end
end % end for every dataset

%% concatenate some things

% degrees matrix (only keep track of one, as they are all the same for every GP. As assumed by Kennedy & O'Hagan)
this.regressionFcn = this.GP{end}.regressionFunction();

% create full regression model matrix
F = this.regressionMatrix();%这个没有输入
 %如果我要修改回归项，就是要修改这个F！！！！！         
% concatenate the hyperparameters
hp = {        0 this.GP{1}.getSigma() this.GP{1}.getProcessVariance() this.GP{1}.getHyperparameters() ;
    this.rho{1} this.GP{2}.getSigma() this.GP{2}.getProcessVariance() this.GP{2}.getHyperparameters()};

% fit model
this = this.updateModel( F, hp );

% set the correct sigma2
this.sigma2 = this.rho{1}.*this.rho{1}.*this.GP{1}.getProcessVariance() + this.GP{2}.getProcessVariance();
%如果把这个cleanup注释掉，可以从外面直接调用GP.predict吗？
%this = this.cleanup();

end
