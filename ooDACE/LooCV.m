%写一个输入是oodace的GP的类的对象的普遍的交叉验证的函数。
%Kriging和Cokriging通用
function [y] = LooCV(mod)
%% 参数提取
sam = mod.getSamples();
val = mod.getValues();
num = size(sam,1);%待测试的样本
inDim = size(sam,2);%模型的维度
hp = mod.hyperparameters{1,1};

if isa(mod,'CoKriging')==1%确认是多保真度
    %1是低精度；2是高精度
    %暂时不考虑两个以上的保真度
    %多保真度的话之对
hp1 = mod.hyperparameters{1,1};
hp2 = mod.hyperparameters{2,1};
GP1 = mod.GP{1,1};
GP2 = mod.GP{2,1};
sam1 = mod.getSamplesIdx(1);
sam2 = mod.getSamplesIdx(2);
val1 = mod.getValuesIdx(1);
val2 = mod.getValuesIdx(2);

num = size(sam2,1);%待测试的样本
sam = sam2;
val = val2;
end


PredictY = zeros(num,1);
for ii = 1:num
 rev = 1:num;
 rev(ii) = [];    
 
%% 进行样本的去一操作%% 设置新模型建立的参数
points_tem = sam(rev,:);
values_tem = val(rev,:);

opts = DefaultOptions();
opts.type = class(mod);%建立与现有模型同类的模型
opts.hp0 = repmat(0.5, 1, inDim);
opts.hpBounds = [repmat(-2, 1, inDim) ; repmat(2, 1, inDim)];%在ooDace中超参数都是以对数的形式保存


if isa(mod,'CoKriging')==1%确认是多保真度
points_tem = {sam1;sam2(rev,:)};
values_tem = {val1;val2(rev,:)};

opts.rho0 = 1; % initial scaling factor between datasets
opts.rhoBounds = [0.1 ; 5]; % scaling factor optimization bounds
end
%% 建立模型
 k = feval( opts.type, opts, opts.hp0, opts.regrFunc, opts.corrFunc);
 k.hyperparameters{1,1} = hp;%将hp写入

 %===================================================%
 if isa(mod,'CoKriging')==1%确认是多保真度
 k.GP = cell(2,1);
 k.GP{1,1} = GP1;
 GP2_new = BasicGaussianProcess(GP2.options, GP2.hyperparameters0, GP2.regressionFcn, GP2.correlationFcn);
 yc = GP1.predict(points_tem{2,1}); % yc unscaled
 d = [values_tem{2,1}, yc]; % note: watch scaling of both entries!
 GP2_new.hyperparameters{1,1} = hp2;
 GP2_new = GP2_new.fit(sam2(rev,:),d);
 k.GP{2,1} = GP2_new;
 k.rho = cell(1,1);
 k.rho{1} = k.GP{2,1}.getRho();
 end
  
 %===================================================%
 k = k.fit( points_tem, values_tem );
 
 
%% 获得预测值
PredictY(ii,1) = k.predict(sam(ii,:));
end

Error = val - PredictY;
NorError = Error./val;
RMSE = sqrt(Error'*Error/num);
NRMSE = sqrt(NorError'*NorError/num);
R2 = 1 - (Error'*Error/num)/(std(val)^2);

y.Y = val;
y.PredictY = PredictY;
y.RMSE = RMSE;
y.NRMSE = NRMSE;
y.R2 = R2;

%plot(val2,list,'s','color',c(1,:),'MarkerSize',12,'linewidth',2);hold on;
%   set(gca,'yticklabel',{'2.5%','3.0%','3.5%','4.0%','4.5%'});
%   set(gca,'xticklabel',{'2.5%','3.0%','3.5%','4.0%','4.5%'});
% temp = valuesH - list';
%temp = (valuesH - list')./valuesH;
%  RMSE(kk) =  sqrt(temp'*temp/21);
%  R2(kk) = 1 - (temp'*temp/21)/(std(valuesH)^2);

% plot([0.025,0.045]*100,[0.025,0.045]*100,'k-');
%  axis([[0.025,0.045,0.025,0.045]*100]);
%  ylabel('Predict Y(%)')
% xlabel('Y(%)')
% set(gca,'FontSize',12);
% hl = legend('Case1','Case2','Case3','Case4','Case5','Location','NorthWest');
% set(hl,'box','off');
% box on
% set(gcf,'unit','centimeters','position',[10 10 12 10])

end

function [options] = DefaultOptions()
options = struct( ...
                'generateHyperparameters0', false, ...
                'hpBounds', [], ... % hyperparameter bounds
                'hpOptimizer', SQPLabOptimizer( 1, 1 ), ... % optimizer class
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