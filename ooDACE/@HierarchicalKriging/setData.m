%2019-8-20
%HK����ģ���еĴ����������ݵĺ���
%�������������Cokriging���в�ͬ
%cokriging========������������Ϣ������������һ������this.sample���nrSamples��idxDataset����ǷֶΣ�
%hierarchicalKriging===this.Sample��������ڴ���Ĳ�����ݣ����this.allsamples������������ݣ�
function [this, samples, values] = setData(this, samples, values)
%û�й�һ������
%��������������ǽ�����������ֵ������һ����������ҶԲ�ͬ���������ĸ�����һ����¼��
if iscell(samples)==1%������Kriging����
    
    % keep array of number of samples
    %��Ԫ�������е�ÿ��Ԫ��Ӧ�ú���
    this.nrSamples = cellfun( @(x) size(x,1), samples );%???????
    
    % generate indices into the datasets
    idx2 = cumsum( this.nrSamples );%cumsum�Ծ�������ۼӣ��ۼӺ��С����
    idx1 = idx2 - this.nrSamples + 1;
    this.idxDataset = [idx1 idx2];
    
    % concat datasets into one ordinary array
    this.allSamples = cell2mat( samples );
    this.allValues = cell2mat( values );
    this = this.setData@BasicGaussianProcess( samples{1}, values{1} );
else%�;���Ϊ��Ӧ�������2020-8-25
    this.samples = samples;
    this.values = values;
    idx2 = 1:size(this.samples,1);%cumsum�Ծ�������ۼӣ��ۼӺ��С����
    idx1 = 1:2;%�����һ��ֵ��ֹ����
    this.idxDataset = [idx1 idx2];
    this = this.setData@BasicGaussianProcess( samples, values );
    
    samples = {[];samples};
    values = {[];values};
end
end
