%2019-8-18
%本程序的作用是作为各个Kriging类代理模型的入口
% ======================================================================
function k = GPfamily( samples, values, type, varargin )
%+++++当前类型++++++
%Kriging
%GeneralizedKriging
%HierarchicalKriging
%CoKriging
%GeneralizedCoKriging
%% 判断samples&values是否匹配
%% 判断type类型与样本是否相符
surfaceInput = 0;
hpInput = 0;
hpRatioInput = 0;
if sum(strcmp(type,{'Kriging','GeneralizedKriging','HighDimensionKriging'}))==1 && iscell(samples)==0 && isempty(varargin)
    disp('Legal HF surrogate');
    inDim = size(samples,2);
elseif sum(strcmp(type,{'HierarchicalKriging','GeneralizedCoKriging','CoKriging'}))==1 && iscell(samples)==1
    disp('Legal MF surrogate');
    inDim = size(samples{1},2);
elseif strcmp(type,'HierarchicalKriging')==1 && sum(strcmp(class(varargin{1,1}),{'Kriging','Cokriging','HierarchicalKriging','function_handle'}))==1
    disp('Legal MF surrogate with surface/handle input');%HK的低精度也可以是一个句柄
    inDim = size(samples,2);
    surfaceInput = 1;
elseif strcmp(type,'Kriging')==1 && sum(strcmp(class(varargin{1,1}),{'double'}))==1
    disp('Legal HF surrogate with hyperparameters');%这个指的是超参数是固定的
    inDim = size(samples,2);
    hpInput = 1;
elseif strcmp(type,'HighDimensionKriging')==1 && sum(strcmp(class(varargin{1,1}),{'cell'}))==1
    inDim = size(samples,2);
    %检查一下indexRatio的格式
    if size(varargin{1,1},1)==2&&size(cell2mat(varargin{1,1}),2)==inDim
         disp('Legal HighDimension HF surrogate with hyperRatio');
    else
        error('The indexRatio cell is illeagal, Check Please!')
    end
    hpRatioInput = 1;
else
    error('Undefined Surrogate Type');
end
%% 对不同的类型设置不同的默认条件
%先设置统一条件
opts = DefaultOptions();
opts.hp0 = repmat(0.5, 1, inDim);
opts.hpBounds = [repmat(-2, 1, inDim) ; repmat(2, 1, inDim)];%在ooDace中超参数都是以对数的形式保存的
opts.type = type;
switch type
    case 'Kriging'
    case 'GeneralizedKriging'
        opts.InputregressionFunc = varargin;
    case 'HierarchicalKriging'
    case 'GeneralizedCoKriging'
    case 'CoKriging'
        opts.rho0 = 1; % initial scaling factor between datasets
        opts.rhoBounds = [0.1 ; 5]; % scaling factor optimization bounds
    case 'HighDimensionKriging'
        opts.hpOptimizer = JADELabOptimizer(1,1);%换一个效率更高的优化器，同时把迭代次数设置的更大
        
        %修改超参数的边界%根据文献来设置
        if hpRatioInput == 1
        indexNum = size(varargin{1,1},2);
        opts.hp0 = repmat(0.5, 1,indexNum );%这里需要优化的变量的个数并不是维度
        opts.hpBounds = [repmat(1e-4, 1, indexNum) ; repmat(100, 1, indexNum)];%%根据文献来设置
        end
end
%% 建立模型
if strcmp(type,'GeneralizedKriging')
    k = feval( opts.type,opts.InputregressionFunc ,opts, opts.hp0, opts.regrFunc, opts.corrFunc);
else
    k = feval( opts.type, opts, opts.hp0, opts.regrFunc, opts.corrFunc);
    if surfaceInput == 1
        k.GP{1}=varargin{1,1};%在这里将低精度响应面输入
    end
    
    if hpInput == 1
        k.hyperparameters{1,1} = varargin{1,1};
    end
    
    if hpRatioInput == 1%仅仅出现在'HighDimensionKriging'中
        k.indexRatio = varargin{1,1};%输入系数
    end
end
%第一个参数可以是函数的句柄或者字符串形式的名称
%在Cokriging类的建立中用到了：hp0？？0.5？？，regrFunc回归模型，corrFunc相关系数方程
k = k.fit( samples, values );
end

function [options] = DefaultOptions()
options = struct( ...
    'generateHyperparameters0', false, ...
    'hpBounds', [], ... % hyperparameter bounds
    'hpOptimizer',SQPLabOptimizer( 1, 1 ), ... %  MatlabGA( 1, 1 )  'hpOptimizer', SQPLabOptimizer( 1, 1 ), ... % optimizer class%这里是调用了一个函数啊。
    'hpLikelihood', @marginalLikelihood, ...
    'sigma20', NaN, ... % initial value for sigma2
    'sigma2Bounds', [-1; 5], ... % sigma2 parameter bounds (in log scale
    'lambda0' ,-Inf, ... % initial lambda values
    'lambdaBounds', [0; 5], ... % lambda parameter bounds (in log scale)
    'Sigma', [], ... % intrinsic covariance matrix (stochastic kriging)
    'reinterpolation', false, ... % reinterpolate error (replaces standard error)
    'lowRankApproximation', false, ... % enable low rank approximation of correlation matrix
    'rankTol', 1e-12, ... % tolerance for lowRankApprox.
    'rankMax', Inf, ... % maximum rank to achieve for lowRankApprox.
    'regressionMaxLevelInteractions', 2, ... % consider maximal two-level interactions
    'debug', false, ... % enables debug plot of the likelihood function
    'regrFunc', 'regpoly0', ...
    'corrFunc', @corrgauss, ...
    'rho0', -Inf, ...
    'rhoBounds', [0.1 ; 5] ...
    );
end
