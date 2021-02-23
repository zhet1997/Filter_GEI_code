
%
% ======================================================================
%> This function optimizes the given function handle
% ======================================================================
function [this, x, fval] = optimize(this, arg )%这个函数的作用是直接调用优化器

    if isa( arg, 'Model' )
        func = @(x) evaluate(arg,x);
    else % assume function handle
        func = arg;%一般是这种
    end

    % some basic settings%将this中的变量输入到this.problem
    [lb, ub] = this.getBounds();
    %if this.getInputDimension()>=10
     this.opts.Generations = this.getInputDimension()*500;
    %end
    this.opts.Generations = min([this.opts.Generations, 5000]);
    this.opts.Generations = max([this.opts.Generations, 1000]);
    %this.problem.nvars = this.getInputDimension();

    [x,fval] = JADE( func, this.getInputDimension(),[lb;ub], this.opts.Generations);
    %[x, y] = JADE(func, 5, [lb;ub],5000);
end