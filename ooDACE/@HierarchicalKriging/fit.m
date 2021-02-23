%2019-7-30%2020-8-23修改%2020-10-30修改
%分层Kriging
% ======================================================================
function this = fit( this, samples, values )

% process data for underlying Kriging class
[this, samples, values] = this.setData( samples, values );%不需要修改
%输入时是一个元胞数组，经过这一步以后就合并为一个完整的矩阵，分块信息在nrsample中。
%2020-10-30实现对于单个HF样本时模型的处理。
%% useful constants
t = length(samples);%samples是一个元胞数组，t就代表精度的重数。
if ~isempty( this.GP )%如果已经算了一些，就继续计算
    start = size(this.GP,1)+1;
%     start = 1;
%     while start <= length(this.GP) && ...
%             all( size(this.getSamplesIdx(start)) == size(this.GP{start}.getSamples()) ) && ...
%             all( all( this.getSamplesIdx(start) ==  this.GP{start}.getSamples() ) )
%         start = start + 1;%all函数的作用是判断一个矩阵中的数字是否全部不为0；
%     end
else
    start = 1;
    this.GP = cell(t,1);
    this.beta = cell(t-1,1);
end
%以上部分保持不变，beta的值


for i=start:t
    
     this.samples = samples{i};
     this.values = values{i};
%     %直接提取对应精度层的数据到元胞数组中
%     samples{i} = this.getSamplesIdx(i);
%     values{i} = this.getValuesIdx(i);
    
    %如果设置了每一层的参数情况，就提取出来；
    %如果没有，就按整体的来；
    options = this.options;
    % use the right Optimizer for this sub-GP (if multiple are given)
    if iscell( options.hpOptimizer )
        options.hpOptimizer = options.hpOptimizer{i};
    end
    
    if i == 1 %在计算第一层时rho不存在，变差d就是value
        options.rho0 = -Inf; % disable rho MLE estimation for the first (i==1) sub-GP
        d = values{i};
        this.GP{i} = BasicGaussianProcess(options, this.hyperparameters0, this.regressionFcn, this.correlationFcn);
        this.GP{i} = this.GP{i}.fit(samples{i}, d);
        
    else
        % rho
        this.options.rho0 = -Inf; % 这里同样不需要计算rho，这个参数决定了计算的模式
        
        %2021-1-6修改
        if isa(this.GP{i-1},'Kriging')||isa(this.GP{i-1},'BasicGaussianProcess')%查看输入是否为Kriging模型
        F = this.GP{i-1}.predict( samples{i} ); % yc unscaled
        elseif isa(this.GP{i-1},'function_handle')%如果输入的是一个句柄
        F = this.GP{i-1}( samples{i} ); 
        end
         
        
        % rho is predicted by the likelihood of the second sub-GP
        % another possible solution is to use least squares, but this gives bad results
        % this.rho{i-1} = abs(yc) \ abs(values{i});
        % d = values{i} - this.rho{i-1} .* yc;
        
        %F = this.regressionMatrix( this.samples );
        %现在F是一个范德蒙矩阵了，在一阶回归的情况下，是一个全是1的列向量。
        
        % if sigma2 is included in hyperparameter optimization, guess initial value if it is Inf/NaN
        if this.optimIdx(:,this.SIGMA2) && ...%这个判断一般是跳过的，暂时不明白他的作用
                isinf(this.options.sigma20)
            % inital extrinsic variance = variance of ordinary regression residuals
            % From stochastic kriging paper
            alpha = 1;%在beta0计算出来之前，初值取为1；
            this.options.sigma20 = log10(var(this.values-F*alpha));%var表示求方差
        end
        
        %% Correlation matrix preprocessing
        
        % (no for loop):
        % calculate i,j indices
        [n ,p] = size(samples{i}); % 'number of samples' 'dimension'
        %==============================================================
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
        %============================================================================== 
        nSamples = 1:n;
        idx = nSamples(ones(n, 1),:);
        a = tril( idx, -1 ); % idx  %抽取下三角矩阵，不含对角线
        b = triu( idx, 1 )'; % idx  %抽取上三角矩阵
        a = a(a~=0); % remove zero's
        b = b(b~=0); % remove zero's
        distIdxPsi = [a b];
        
        % calculate manhattan distance%计算曼哈顿距离
        %this.samples是private
        dist = samples{i}(a,:) - samples{i}(b,:);%做了上面这么多就是为了让所有样本位置两两相减
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
            hp = {this.getRho log10(this.getSigma()) log10(this.sigma2) this.getHyperparameters()};
        end
        
        % Construct model
        this = this.updateModel(F, hp);%这个update就是生成响应面的过程，前面都是在准备参数
        
        
    end%if i=1;
    
    
    
    
    
    %% concatenate some things
    
    
end
