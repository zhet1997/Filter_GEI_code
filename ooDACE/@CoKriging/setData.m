%> @file "@CoKriging/setData.m"
%> @authors Ivo Couckuyt
%> @version 1.4 ($Revision$)
%> @date $LastChangedDate$
%> @date Copyright 2010-2013
%>
%> This file is part of the ooDACE toolbox
%> and you can redistribute it and/or modify it under the terms of the
%> GNU Affero General Public License version 3 as published by the
%> Free Software Foundation.  With the additional provision that a commercial
%> license must be purchased if the ooDACE toolbox is used, modified, or extended
%> in a commercial setting. For details see the included LICENSE.txt file.
%> When referring to the ooDACE toolbox please make reference to the corresponding
%> publications:
%>   - Blind Kriging: Implementation and performance analysis
%>     I. Couckuyt, A. Forrester, D. Gorissen, F. De Turck, T. Dhaene,
%>     Advances in Engineering Software,
%>     Vol. 49, pp. 1-13, July 2012.
%>   - Surrogate-based infill optimization applied to electromagnetic problems
%>     I. Couckuyt, F. Declercq, T. Dhaene, H. Rogier, L. Knockaert,
%>     International Journal of RF and Microwave Computer-Aided Engineering (RFMiCAE),
%>     Special Issue on Advances in Design Optimization of Microwave/RF Circuits and Systems,
%>     Vol. 20, No. 5, pp. 492-501, September 2010. 
%>
%> Contact : ivo.couckuyt@ugent.be - http://sumo.intec.ugent.be/?q=ooDACE
%> Signature
%>	this = setData(this, samples, values)
%
% ======================================================================
%> Concatenate sample/values cell array to numeric array
%> passing the resulting dataset to the underlying base method.
% ======================================================================
function this = setData(this, samples, values)
%Cokriging就没有归一化处理。
    % keep array of number of samples
    %对元胞数组中的每个元胞应用函数
    this.nrSamples = cellfun( @(x) size(x,1), samples );%保存了不同精度的样本个数
    
    % generate indices into the datasets
    idx2 = cumsum( this.nrSamples );%cumsum是matlab中计算依次累加的函数，即从上加到该位置的总和
    idx1 = idx2 - this.nrSamples + 1;
    this.idxDataset = [idx1 idx2]; %储存了分块信息
    
    % concat datasets into one ordinary array
    samples = cell2mat( samples );
    values = cell2mat( values );
    %a=this.setData@BasicGaussianProcess( samples, values );
    this = this.setData@BasicGaussianProcess( samples, values );
end
