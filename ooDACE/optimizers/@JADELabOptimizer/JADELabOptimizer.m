classdef JADELabOptimizer < Optimizer
	
	% private members
	properties (SetAccess = 'public', GetAccess = 'public')%(SetAccess = 'private', GetAccess = 'private')
		opts;%没有problem这一选项
    end
    
	methods

		% ======================================================================
        %> @brief Class constructor
        %> @return instance of the class
        % ======================================================================
		function this = JADELabOptimizer(varargin)%输入是（1，1）%这个构造函数的作用是定义JADE里的基本参数
			% call superclass
			this = this@Optimizer(varargin{:});

			% GENETIC ALGORITHM
			opts = this.defaultJADE();

			% default case
			if(nargin == 1)%如果输入一个变量的话就是具体的参数
				config = varargin{1};
                %这个输入的config应该是有一个标准的格式的
% 				opts.Generations = config.self.getIntOption( 'Generations', 1000 );
% 				opts.EliteCount = config.self.getIntOption( 'EliteCount' ,2 );
% 				opts.CrossoverFraction = config.self.getDoubleOption( 'CrossoverFraction', 0.8 );
% 				opts.PopInitRange = [-1;1];
% 				opts.PopulationSize = [ str2num( config.self.getOption( 'PopulationSize', '20' ) ) ];
% 				opts.MigrationInterval = config.self.getIntOption( 'MigrationInterval', 20 );
% 				opts.MigrationFraction = config.self.getDoubleOption( 'MigrationFraction', 0.2 );
% 				opts.Vectorize = char( config.self.getOption( 'Vectorize', 'on' ) );
% 				%opts.FitnessScalingFcn = @fitscalingprop, ...
% 				%@fmincon, ...
% 				opts.HybridFcn = str2func( char( config.self.getOption( 'HybridFcn', '[]' ) ) );
% 				opts.HybridFcn = [];
% 				% must change the mutation function so that it respects the boundaries
% 				% !!! important !!!
% 				%opts.MutationFcn = {@mutationadaptfeasible, [1], [1]};
% 				opts.MutationFcn = @mutationuniform;
				
			% custom constructors
			elseif(nargin == 2)%就是这种情况
				% no options, take defaults (only options are for base class
			%elseif(nargin == 3)
				%First 2 are parsed by base class
				%nvar = varargin{1};
				%nobj = varargin{2};
				%opts = gaoptimset( opts, varargin{3} );
			else
				error('Invalid number of arguments given');    
			end

			%opts.MigrationDirection = 'both';
			
			% IMPORTANT!!!
			% if this is set to the default value, negative fitness
			% function values are not allowed!!!
			%opts.StallGenLimit = inf;

            %这里定义了problem,基本上都是空的。
			this.opts = opts;
		end % constructor
        
		[this, x, fval] = optimize(this, arg );
		size = getPopulationSize(this);
		this = setInputConstraints( this, con );

	
    
    function opts = defaultJADE(this)
        		opts.Generations = 5000;%默认最大迭代次数
				opts.PopInitRange = [-1;1];
				opts.PopulationSize =100;  
    end
    
    end % methods
end % classdef
