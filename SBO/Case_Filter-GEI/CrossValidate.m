clc;clear;

data = importdata('D:\others\PHY\EngineeringTestCases\Data\Case4.mat');
c = linspecer(5);
for kk=1:5
pointsH = [data.PointsHigh{kk,1}];
pointsL = [data.PointsLow{kk,1}];
valuesH = [data.ValuesHigh{kk,1}];
valuesL = [data.ValuesLow{kk,1}];
 points = {pointsL;pointsH};
 values = {valuesL;valuesH};

modCoKriging = GPfamily( points, values,'CoKriging');
hp1 = modCoKriging.hyperparameters{1,1};
hp2 = modCoKriging.hyperparameters{2,1};
GP1 = modCoKriging.GP{1,1};
GP2 = modCoKriging.GP{2,1};
list = zeros(1,21);

for ii = 1:21
 rev = 1:21;
 rev(ii) = [];
    
points_tem = {pointsL;pointsH(rev,:)};
values_tem = {valuesL;valuesH(rev,:)};

inDim = 7;
opts = DefaultOptions();
opts.hp0 = repmat(0.5, 1, inDim);
opts.hpBounds = [repmat(-2, 1, inDim) ; repmat(2, 1, inDim)];%在ooDace中超参数都是以对数的形式保存的
opts.type = 'CoKriging';

opts.rho0 = 1; % initial scaling factor between datasets
opts.rhoBounds = [0.1 ; 5]; % scaling factor optimization bounds


 k = feval( opts.type, opts, opts.hp0, opts.regrFunc, opts.corrFunc);
 %===================================================%
 k.GP = cell(2,1);
 k.GP{1,1} = GP1;
 GP2_new = BasicGaussianProcess(GP2.options, GP2.hyperparameters0, GP2.regressionFcn, GP2.correlationFcn);
 yc = GP1.predict(pointsH(rev,:)); % yc unscaled
 d = [valuesH(rev,:) yc]; % note: watch scaling of both entries!
 GP2_new.hyperparameters{1,1} = hp2;
 GP2_new = GP2_new.fit(pointsH(rev,:),d);
 k.GP{2,1} = GP2_new;
 k.rho = cell(1,1);
 k.rho{1} = k.GP{2,1}.getRho();
 %===================================================%
 k = k.fit( points_tem, values_tem );
 
 list(ii) = k.predict(pointsH(ii,:));
end
 plot(valuesH,list,'s','color',c(kk,:),'MarkerSize',12,'linewidth',2);hold on;

end
plot([0.025,0.045],[0.025,0.045],'k-');
 axis([[0.025,0.045,0.025,0.045]]);
 ylabel('Predict Y')
xlabel('Y')
set(gca,'FontSize',12);
hl = legend('Example1','Example2','Example3','Example4','Example5','Location','NorthWest');
set(hl,'box','off');
box on
set(gcf,'unit','centimeters','position',[10 10 12 10])
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