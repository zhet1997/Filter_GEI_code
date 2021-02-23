%> @file "@BasicGaussianProcess/fit.m"
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
% ======================================================================
%2019-6-8好好整理一下这个fit是怎么工作的。
function this = fit( this, samples, values )
%这里的this认为是一个Kriging类；
    %% store data (can be overrided, e.g., Kriging does a scaling before storing)
    this = this.setData( samples, values );%输入的values和this.values有所不同？？？
%不同是因为在setdata@kriging中做了归一化处理
    %% useful constants
    [n ,p] = size(this.samples); % 'number of samples' 'dimension'
%这一步有些重复，p表示维度
    %% Preprocessing

    % Calculate Sigma covariance matrix if it is not included in the MLE
    if ~this.optimIdx(1,this.LAMBDA)
        
        % stochastic kriging
        if ~isempty( this.options.Sigma )
            this.Sigma = this.options.Sigma;
        else
            % add a small number to ease ill-conditioning
            this.Sigma = (n+10)*eps;%这个步骤应该是要正则化防止病态矩阵出现。
            %值得注意的是，这里的大写Sigma似乎与小写的又较大的意义区别
        end

        o = (1:n)';
        this.Sigma = sparse( o, o, this.Sigma);%创建了一个对角矩阵
        %用sparse来创建稀疏矩阵
    end

    %% Regression matrix preprocessing  
    %回归矩阵的准备工作
    if this.options.regressionMaxLevelInteractions > p%这个参数的意义暂时不明
        warning('regressionMaxLevelInteractions is larger than the number of dimensions.');
        this.options.regressionMaxLevelInteractions = p;
    end

    if ischar( this.regressionFcn )

        % easy to use + compatible with DACE toolbox
        switch this.regressionFcn%这一步是要选择拟合的方法
            case ''
                dj = []; % no regression function (constant=0)
            case 'regpoly0'%一般使用这个
                dj = 0; % constant
            case 'regpoly1'
                dj = [0 ; 1]; % constant + linear terms
            case 'regpoly2'
                dj = [0 ; 1 ; 2]; % constant + linear + quadratic interactions
            case 'regpoly3'
                dj = [0 ; 1 ; 2 ; 3]; % all the above + cubic interactions
            case 'regpoly4'
                dj = [0 ; 1 ; 2 ; 3 ; 4]; % all the above + quartic interactions
        end

        this.regressionFcn = this.generateDegrees( dj );
    end

    % Construct model matrix F
    F = this.regressionMatrix( this.samples );
    %现在F是一个范德蒙矩阵了，在一阶回归的情况下，是一个全是1的列向量。
    
    % if sigma2 is included in hyperparameter optimization, guess initial value if it is Inf/NaN
    if this.optimIdx(:,this.SIGMA2) && ...%这个判断一般是跳过的，暂时不明白他的作用
       isinf(this.options.sigma20)
        % inital extrinsic variance = variance of ordinary regression residuals
        % From stochastic kriging paper
        alpha = (F'*F)\(F'*this.values);%这里看不懂%从效果上来说，一介相当于取平均
        this.options.sigma20 = log10(var(this.values-F*alpha));%var表示求方差
    end

    %% Correlation matrix preprocessing

    % (no for loop):
    % calculate i,j indices
    nSamples = 1:n;
    idx = nSamples(ones(n, 1),:);
    a = tril( idx, -1 ); % idx  %抽取下三角矩阵，不含对角线
    b = triu( idx, 1 )'; % idx  %抽取上三角矩阵
    a = a(a~=0); % remove zero's
    b = b(b~=0); % remove zero's
    distIdxPsi = [a b];

    % calculate manhattan distance%计算曼哈顿距离
    %this.samples是private
    dist = this.samples(a,:) - this.samples(b,:);%做了上面这么多就是为了让所有样本位置两两相减
    %原来矩阵里用向量可以实现重新排序；
    %为了不用for循环增加时间真是够拼的！！！！

    % NOTE: double=8 bytes, 500 samples 
    % a/b is 1 mb each... idx is 2 mb
    % . a/b and idx reside in memory but are not used anymore -> CLEAR
    % only needed is distIdxPsi (2 mb) and dist (2 mb)
    clear a b idx%在不用后删除变量，可以节约内存哦

    this.dist = dist; % Sample inter-distance
    this.distIdxPsi = distIdxPsi; % indexing needed for psiD%position？？？记录了两两间距离的位置

    % set initial hyperparameters (if not already set)
    % Generating hyperparameters0 should be done by BasisFunctions (need BF
    % classes for that)
    if this.options.generateHyperparameters0%一般跳过，暂时不看
        % From stochastic kriging paper
        % make correlation = 1/2 at average distance
        switch func2str(this.correlationFcn)
            case 'corrgauss'
                avg_dist = mean(abs(this.dist));
                this.hyperparameters0 = (log(2)/p)*(avg_dist.^(-2));
            case 'correxp'
                avg_dist = mean(abs(this.dist));
                this.hyperparameters0 = (log(2)/p)*(avg_dist.^(-1));
            otherwise
                this.hyperparameters0 = 10.^0.5*ones(1,this.optimNrParameters(end));
        end
        this.hyperparameters0 = log10(this.hyperparameters0);
    end
    
    % tune hyperparameters
    if isempty( this.hyperparameters )%要输入超参数了
        hp = {this.options.rho0 this.options.lambda0 this.options.sigma20 this.hyperparameters0};
        %上面没有MLE的过程，所以这里的0应该代表了初始取值。
        if ~isempty( this.options.hpOptimizer ) % no optimization
            % use internal optimizer
            [this ,optimHp ,perf] = this.tuneParameters(F);%这一步的参数都是什么意思？？？
            %这一步用时比较多
            %optimHp存放了超参数theta
            %到此为止已经获得了超参数。
         hp(1,this.optimIdx) = mat2cell( optimHp, 1, this.optimNrParameters );
        % else fixed hp (or optimized from the outside)
        end
    else
        % for xval AND rebuildBestModels (samples changes, model parameters
        % stay the same
        %如果已经参在超参数就跳过
        hp = {this.getRho log10(this.getSigma()) log10(this.sigma2) this.getHyperparameters()};
    end

    % Construct model
    this = this.updateModel(F, hp);%这个update就是生成响应面的过程，前面都是在准备参数
    
      %F似乎一直都是空的。
    % NOTE: some variables can now be cleared from memory by calling cleanup()
    %> @note Kriging can't do a cleanup automatically, if needed cleanup() can be called manually.
end
