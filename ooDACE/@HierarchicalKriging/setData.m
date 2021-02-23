%2019-8-20
%HK代理模型中的处理输入数据的函数
%本函数的情况与Cokriging又有不同
%cokriging========把所有样本信息连接起来放在一个矩阵this.sample里，用nrSamples和idxDataset来标记分段；
%hierarchicalKriging===this.Sample里放置正在处理的层的数据，添加this.allsamples来存放所有数据；
function [this, samples, values] = setData(this, samples, values)
%没有归一化处理。
%这个函数的作用是将样本坐标与值都放在一个矩阵里，并且对不同精度样本的个数做一个记录。
if iscell(samples)==1%正常的Kriging输入
    
    % keep array of number of samples
    %对元胞数组中的每个元胞应用函数
    this.nrSamples = cellfun( @(x) size(x,1), samples );%???????
    
    % generate indices into the datasets
    idx2 = cumsum( this.nrSamples );%cumsum对矩阵进行累加，累加后大小不变
    idx1 = idx2 - this.nrSamples + 1;
    this.idxDataset = [idx1 idx2];
    
    % concat datasets into one ordinary array
    this.allSamples = cell2mat( samples );
    this.allValues = cell2mat( values );
    this = this.setData@BasicGaussianProcess( samples{1}, values{1} );
else%低精度为响应面的输入2020-8-25
    this.samples = samples;
    this.values = values;
    idx2 = 1:size(this.samples,1);%cumsum对矩阵进行累加，累加后大小不变
    idx1 = 1:2;%随便设一个值防止报错。
    this.idxDataset = [idx1 idx2];
    this = this.setData@BasicGaussianProcess( samples, values );
    
    samples = {[];samples};
    values = {[];values};
end
end
