%> @file "@BasicGaussianProcess/tuneParameters.m"
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
%>	[this optimHp perf] = tuneParameters( this, F )
%
% ======================================================================
%> Setups and invokes the optimizer
% ======================================================================
function [this ,optimHp ,perf] = tuneParameters( this, F )

[n,p] = size(this.samples); % 'number of samples' 'dimension'

func = @(optimParam) likelihood( this, F, optimParam );%用到了最大似然函数
%optimParam表示参数

allParam = {this.options.rho0 this.options.lambda0 this.options.sigma20 this.hyperparameters0};

allBounds = {this.options.rhoBounds this.options.lambdaBounds this.options.sigma2Bounds this.options.hpBounds};
% rho的边界    %       %sigma2 边界   %hp边界  ？？？？？
% select only variables and bounds of variables that we optimize
initialPopulation = cell2mat( allParam(:,this.optimIdx) );
bounds = cell2mat( allBounds(:,this.optimIdx) );

% number of hyperparameters
dim = size( bounds, 2 );

%% Optimize   %这里就是最关键的优化过程了
%用到作者写在文件夹optimizer中的优化器
this.options.hpOptimizer = this.options.hpOptimizer.setDimensions( dim, 1 );%设置维度
this.options.hpOptimizer = this.options.hpOptimizer.setInitialPopulation( initialPopulation  );%设置初始种群数
this.options.hpOptimizer = this.options.hpOptimizer.setBounds( bounds(1,:), bounds(2,:) );%设置边界
%这里先对优化器输入各设定参数========================================
%这明明是类里的函数，写成这种样子
[this.options.hpOptimizer, pop ,opvalue] = optimize( this.options.hpOptimizer, func );%参数为1.优化参数2.优化对象
%这个程序任然使用的使matlab内置的优化方法sql，单独写一个函数是为了封装配置各参数的过程。
%pop 是最优坐标 opvalue是最优值  这里用的是sqp序列二次规划
% boundary check (=nice hint to the user when bounds are too
% small)%检查优化得到的超参数是否在边界上。
lbCheck = abs(bounds(1,:) - pop(1,:));%从这里看，pop就是参数的结果
ubCheck = abs(bounds(2,:) - pop(1,:));
if any( min( lbCheck, ubCheck ) < eps )
    warning('Found optimum is close to the boundaries. You may try enlarging the hyperparameter bounds.');
end

% return optimum and the performance (likelihood)
optimHp = pop(1,:); % take best one (if it is a population)%说明可能有多个优化结果
%三个超参数的结果存在这里。
perf = opvalue(1,:);

if this.options.debug%不用看
    persistent likPlot
    
    if isempty(likPlot)
        likPlot = figure;
    else
        figure(likPlot);
    end
    
    % likelihood contour plot
	this.plotLikelihood(func, optimHp, perf);
    title( [func2str(this.options.hpLikelihood) ' plot'], 'FontSize', 14 );

    % initial population and minimum
	plot(pop(2:end,1), pop(2:end,2),'ko','Markerfacecolor','r');
	hold off
    
    optimHp
    perf

	%disp('Press a key to continue...');
	%pause;
end

end
