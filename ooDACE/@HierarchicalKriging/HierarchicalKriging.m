classdef HierarchicalKriging < BasicGaussianProcess

	properties (Access = public)%把private改为了protected
        
        % Sub-Gaussian Processes (one for each dataset)
        GP = [];
		
        % preprocessing values
        nrSamples = []; %>< array of number of samples
		idxDataset = []; %>< indices to samples/values to get only dataset row i
        
        
        allSamples = [];
        allValues = [];
        beta
	end

	% PUBLIC
	methods( Access = public )

		% CTor
		function this = HierarchicalKriging(varargin)
            this = this@BasicGaussianProcess(varargin{:});
            
            % warn the user early if something is not possible
            if this.optimIdx(1,this.SIGMA2)
               error('Including sigma2 in the optimization process is not possible with cokriging.'); 
            end
		end % constructor

		%% Function definitions (mostly getters)
        
		% ======================================================================
        %> @brief Returns samples of dataset t
        %>
        %> @param t index of dataset to retrieve
        %> @retval samples samples of dataset t
        % ======================================================================
		function samples = getSamplesIdx(this, t)
            samples = this.allSamples;
            samples = samples(this.idxDataset(t,1):this.idxDataset(t,2),:);
        end
        
        % ======================================================================
        %> @brief Returns values of dataset t
        %>
        %> @param t index of dataset to retrieve
        %> @retval values values of dataset t
        % ======================================================================
		function values = getValuesIdx(this,t)
            values = this.allValues;
            values = values(this.idxDataset(t,1):this.idxDataset(t,2),:);
        end
        
        function beta = getBeta(this,t)
            %此时已经完成了t-1层的响应面的建立；
            %导入第t层的样本信息；
            samples = this.getSamplesIdx(t);
            values = this.getValuesIdx(t);
            F = this.GP{t-1}.predict( samples );%这里获取了低精度响应面上对应位置样本的预测值
            Ft = this.C\F;
            Yt = this.C\values;
            beta = (Ft*Yt)/(Ft*Ft);
        end
		        
		%% Function 	
        
%         function beta = getBeta(obj)
%             obj.beta =  
%          end

		% ======================================================================
        %> @brief Fits a gaussian process for multi-fidelity datasets
        %>
        %> @param samples input sample matrix (cell array)
        %> @param values output value matrix (cell array)
        % ======================================================================
		this = fit(this, samples, values);
        
		% ======================================================================
        %> @brief Returns the regression function
        %>
        %> @param varargin Options
        %> @retval regressionFcn Degree matrix representing the regression function
        %> @retval expression Symbolic expression
        %> @retval terms Cell array of the individual terms
        % ======================================================================
		[regressionFcn ,expression ,terms] = regressionFunction(this,varargin);
        
        % ======================================================================
        %> @brief Returns the internal correlation function handle
        %>        
        %> @param varargin Options
        %> @retval correlationFcn String of correlation function
		[correlationFcn ,expression] = correlationFunction(this,varargin);

	end % methods public
    
    %% PROTECTED (needed by @KrigingModel of SUMO toolbox)
    methods( Access = protected )
		
        %% HierarchicalKriging constructs custom correlation and regression matrices
        % and treats samples/values different (as cell array instead of numeric array)
        
        % ======================================================================
        %> @brief Sets samples and values matrix
        %>
        %> @param samples input sample matrix (cell array)
        %> @param values  output value matrix (cell array)
        % ======================================================================
        [this, samples, values] = setData(this, samples, values);
        

 
        
        %=======================================
        [this, err, dsigma2] = updateRegression( this, F, hp )
    end 
        methods( Access = public )
        %==========================================================
        [y ,sigma2] = predict(this, points)
    end % methods protected

    %% PRIVATE
	methods( Access = private )
	end % methods private
    
    methods( Static )

        % ======================================================================
        %> @brief Returns a default options structure
        %>
        %> @retval options Options structure
        % ======================================================================
        function options = getDefaultOptions()
            options = Kriging.getDefaultOptions();
            % We can optional choose another optimizer for each sub-Kriging
            % model
            %optimopts.GradObj = 'on';
            %optimopts.DerivativeCheck = 'on';
            %optimopts.Diagnostics = 'on';
            %optimopts.Algorithm = 'active-set';
            %optimopts.MaxFunEvals = 1000;
            %optimopts.MaxIter = 500;
            %optimopts.TolX = eps; % 1e-15;
            %optimopts.TolFun = eps; %1e-15;
            %options.hpOptimizer = {options.hpOptimizer MatlabOptimizer( 1, 1, optimopts )};
            % enable rho for cokriging
            options.rho0 = -Inf;%HK不需要优化参数rho
             % initial scaling factor between datasets
            options.rhoBounds = [0.1 ; 5]; % scaling factor optimization bounds
        end
    end % methods static
    
end % classdef
