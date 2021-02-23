%2019-8-18
%���������������Ϊ����Kriging�����ģ�͵����
% ======================================================================
function k = GPfamily( samples, values, type, varargin )
%+++++��ǰ����++++++
%Kriging
%GeneralizedKriging
%HierarchicalKriging
%CoKriging
%GeneralizedCoKriging
%% �ж�samples&values�Ƿ�ƥ��
%% �ж�type�����������Ƿ����
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
    disp('Legal MF surrogate with surface/handle input');%HK�ĵ;���Ҳ������һ�����
    inDim = size(samples,2);
    surfaceInput = 1;
elseif strcmp(type,'Kriging')==1 && sum(strcmp(class(varargin{1,1}),{'double'}))==1
    disp('Legal HF surrogate with hyperparameters');%���ָ���ǳ������ǹ̶���
    inDim = size(samples,2);
    hpInput = 1;
elseif strcmp(type,'HighDimensionKriging')==1 && sum(strcmp(class(varargin{1,1}),{'cell'}))==1
    inDim = size(samples,2);
    %���һ��indexRatio�ĸ�ʽ
    if size(varargin{1,1},1)==2&&size(cell2mat(varargin{1,1}),2)==inDim
         disp('Legal HighDimension HF surrogate with hyperRatio');
    else
        error('The indexRatio cell is illeagal, Check Please!')
    end
    hpRatioInput = 1;
else
    error('Undefined Surrogate Type');
end
%% �Բ�ͬ���������ò�ͬ��Ĭ������
%������ͳһ����
opts = DefaultOptions();
opts.hp0 = repmat(0.5, 1, inDim);
opts.hpBounds = [repmat(-2, 1, inDim) ; repmat(2, 1, inDim)];%��ooDace�г����������Զ�������ʽ�����
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
        opts.hpOptimizer = JADELabOptimizer(1,1);%��һ��Ч�ʸ��ߵ��Ż�����ͬʱ�ѵ����������õĸ���
        
        %�޸ĳ������ı߽�%��������������
        if hpRatioInput == 1
        indexNum = size(varargin{1,1},2);
        opts.hp0 = repmat(0.5, 1,indexNum );%������Ҫ�Ż��ı����ĸ���������ά��
        opts.hpBounds = [repmat(1e-4, 1, indexNum) ; repmat(100, 1, indexNum)];%%��������������
        end
end
%% ����ģ��
if strcmp(type,'GeneralizedKriging')
    k = feval( opts.type,opts.InputregressionFunc ,opts, opts.hp0, opts.regrFunc, opts.corrFunc);
else
    k = feval( opts.type, opts, opts.hp0, opts.regrFunc, opts.corrFunc);
    if surfaceInput == 1
        k.GP{1}=varargin{1,1};%�����ｫ�;�����Ӧ������
    end
    
    if hpInput == 1
        k.hyperparameters{1,1} = varargin{1,1};
    end
    
    if hpRatioInput == 1%����������'HighDimensionKriging'��
        k.indexRatio = varargin{1,1};%����ϵ��
    end
end
%��һ�����������Ǻ����ľ�������ַ�����ʽ������
%��Cokriging��Ľ������õ��ˣ�hp0����0.5������regrFunc�ع�ģ�ͣ�corrFunc���ϵ������
k = k.fit( samples, values );
end

function [options] = DefaultOptions()
options = struct( ...
    'generateHyperparameters0', false, ...
    'hpBounds', [], ... % hyperparameter bounds
    'hpOptimizer',SQPLabOptimizer( 1, 1 ), ... %  MatlabGA( 1, 1 )  'hpOptimizer', SQPLabOptimizer( 1, 1 ), ... % optimizer class%�����ǵ�����һ����������
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
