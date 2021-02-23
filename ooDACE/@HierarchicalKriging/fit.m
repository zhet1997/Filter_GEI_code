%2019-7-30%2020-8-23�޸�%2020-10-30�޸�
%�ֲ�Kriging
% ======================================================================
function this = fit( this, samples, values )

% process data for underlying Kriging class
[this, samples, values] = this.setData( samples, values );%����Ҫ�޸�
%����ʱ��һ��Ԫ�����飬������һ���Ժ�ͺϲ�Ϊһ�������ľ��󣬷ֿ���Ϣ��nrsample�С�
%2020-10-30ʵ�ֶ��ڵ���HF����ʱģ�͵Ĵ���
%% useful constants
t = length(samples);%samples��һ��Ԫ�����飬t�ʹ����ȵ�������
if ~isempty( this.GP )%����Ѿ�����һЩ���ͼ�������
    start = size(this.GP,1)+1;
%     start = 1;
%     while start <= length(this.GP) && ...
%             all( size(this.getSamplesIdx(start)) == size(this.GP{start}.getSamples()) ) && ...
%             all( all( this.getSamplesIdx(start) ==  this.GP{start}.getSamples() ) )
%         start = start + 1;%all�������������ж�һ�������е������Ƿ�ȫ����Ϊ0��
%     end
else
    start = 1;
    this.GP = cell(t,1);
    this.beta = cell(t-1,1);
end
%���ϲ��ֱ��ֲ��䣬beta��ֵ


for i=start:t
    
     this.samples = samples{i};
     this.values = values{i};
%     %ֱ����ȡ��Ӧ���Ȳ�����ݵ�Ԫ��������
%     samples{i} = this.getSamplesIdx(i);
%     values{i} = this.getValuesIdx(i);
    
    %���������ÿһ��Ĳ������������ȡ������
    %���û�У��Ͱ����������
    options = this.options;
    % use the right Optimizer for this sub-GP (if multiple are given)
    if iscell( options.hpOptimizer )
        options.hpOptimizer = options.hpOptimizer{i};
    end
    
    if i == 1 %�ڼ����һ��ʱrho�����ڣ����d����value
        options.rho0 = -Inf; % disable rho MLE estimation for the first (i==1) sub-GP
        d = values{i};
        this.GP{i} = BasicGaussianProcess(options, this.hyperparameters0, this.regressionFcn, this.correlationFcn);
        this.GP{i} = this.GP{i}.fit(samples{i}, d);
        
    else
        % rho
        this.options.rho0 = -Inf; % ����ͬ������Ҫ����rho��������������˼����ģʽ
        
        %2021-1-6�޸�
        if isa(this.GP{i-1},'Kriging')||isa(this.GP{i-1},'BasicGaussianProcess')%�鿴�����Ƿ�ΪKrigingģ��
        F = this.GP{i-1}.predict( samples{i} ); % yc unscaled
        elseif isa(this.GP{i-1},'function_handle')%����������һ�����
        F = this.GP{i-1}( samples{i} ); 
        end
         
        
        % rho is predicted by the likelihood of the second sub-GP
        % another possible solution is to use least squares, but this gives bad results
        % this.rho{i-1} = abs(yc) \ abs(values{i});
        % d = values{i} - this.rho{i-1} .* yc;
        
        %F = this.regressionMatrix( this.samples );
        %����F��һ�������ɾ����ˣ���һ�׻ع������£���һ��ȫ��1����������
        
        % if sigma2 is included in hyperparameter optimization, guess initial value if it is Inf/NaN
        if this.optimIdx(:,this.SIGMA2) && ...%����ж�һ���������ģ���ʱ��������������
                isinf(this.options.sigma20)
            % inital extrinsic variance = variance of ordinary regression residuals
            % From stochastic kriging paper
            alpha = 1;%��beta0�������֮ǰ����ֵȡΪ1��
            this.options.sigma20 = log10(var(this.values-F*alpha));%var��ʾ�󷽲�
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
                this.Sigma = (n+10)*eps;%�������Ӧ����Ҫ���򻯷�ֹ��̬������֡�
                %ֵ��ע����ǣ�����Ĵ�дSigma�ƺ���Сд���ֽϴ����������
            end
            
            o = (1:n)';
            this.Sigma = sparse( o, o, this.Sigma);%������һ���ԽǾ���
            %��sparse������ϡ�����
        end
        %============================================================================== 
        nSamples = 1:n;
        idx = nSamples(ones(n, 1),:);
        a = tril( idx, -1 ); % idx  %��ȡ�����Ǿ��󣬲����Խ���
        b = triu( idx, 1 )'; % idx  %��ȡ�����Ǿ���
        a = a(a~=0); % remove zero's
        b = b(b~=0); % remove zero's
        distIdxPsi = [a b];
        
        % calculate manhattan distance%���������پ���
        %this.samples��private
        dist = samples{i}(a,:) - samples{i}(b,:);%����������ô�����Ϊ������������λ���������
        %ԭ������������������ʵ����������
        %Ϊ�˲���forѭ������ʱ�����ǹ�ƴ�ģ�������
        
        % NOTE: double=8 bytes, 500 samples
        % a/b is 1 mb each... idx is 2 mb
        % . a/b and idx reside in memory but are not used anymore -> CLEAR
        % only needed is distIdxPsi (2 mb) and dist (2 mb)
        clear a b idx%�ڲ��ú�ɾ�����������Խ�Լ�ڴ�Ŷ
        
        this.dist = dist; % Sample inter-distance
        this.distIdxPsi = distIdxPsi; % indexing needed for psiD%position��������¼������������λ��
        
        % set initial hyperparameters (if not already set)
        % Generating hyperparameters0 should be done by BasisFunctions (need BF
        % classes for that)
        if this.options.generateHyperparameters0%һ����������ʱ����
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
        if isempty( this.hyperparameters )%Ҫ���볬������
            hp = {this.options.rho0 this.options.lambda0 this.options.sigma20 this.hyperparameters0};
            %����û��MLE�Ĺ��̣����������0Ӧ�ô����˳�ʼȡֵ��
            if ~isempty( this.options.hpOptimizer ) % no optimization
                % use internal optimizer
                [this ,optimHp ,perf] = this.tuneParameters(F);%��һ���Ĳ�������ʲô��˼������
                %��һ����ʱ�Ƚ϶�
                %optimHp����˳�����theta
                %����Ϊֹ�Ѿ�����˳�������
                hp(1,this.optimIdx) = mat2cell( optimHp, 1, this.optimNrParameters );
                % else fixed hp (or optimized from the outside)
            end
        else
            % for xval AND rebuildBestModels (samples changes, model parameters
            % stay the same
            hp = {this.getRho log10(this.getSigma()) log10(this.sigma2) this.getHyperparameters()};
        end
        
        % Construct model
        this = this.updateModel(F, hp);%���update����������Ӧ��Ĺ��̣�ǰ�涼����׼������
        
        
    end%if i=1;
    
    
    
    
    
    %% concatenate some things
    
    
end
