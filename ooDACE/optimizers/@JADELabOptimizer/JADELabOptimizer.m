classdef JADELabOptimizer < Optimizer
	
	% private members
	properties (SetAccess = 'public', GetAccess = 'public')%(SetAccess = 'private', GetAccess = 'private')
		opts;%û��problem��һѡ��
    end
    
	methods

		% ======================================================================
        %> @brief Class constructor
        %> @return instance of the class
        % ======================================================================
		function this = JADELabOptimizer(varargin)%�����ǣ�1��1��%������캯���������Ƕ���JADE��Ļ�������
			% call superclass
			this = this@Optimizer(varargin{:});

			% GENETIC ALGORITHM
			opts = this.defaultJADE();

			% default case
			if(nargin == 1)%�������һ�������Ļ����Ǿ���Ĳ���
				config = varargin{1};
                %��������configӦ������һ����׼�ĸ�ʽ��
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
			elseif(nargin == 2)%�����������
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

            %���ﶨ����problem,�����϶��ǿյġ�
			this.opts = opts;
		end % constructor
        
		[this, x, fval] = optimize(this, arg );
		size = getPopulationSize(this);
		this = setInputConstraints( this, con );

	
    
    function opts = defaultJADE(this)
        		opts.Generations = 5000;%Ĭ������������
				opts.PopInitRange = [-1;1];
				opts.PopulationSize =100;  
    end
    
    end % methods
end % classdef
