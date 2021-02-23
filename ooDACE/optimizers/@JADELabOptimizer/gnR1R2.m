function [r1, r2] = gnR1R2(NP1, NP2, r0)

% 生成两个列向量 r1 和 r2 范围分别为 NP1 和 NP2
% r1 元素属于 {1, 2, ..., NP1} 且 r1(i) ~= r0(i)
% r2 元素属于 {1, 2, ..., NP2} 且 r2(i) ~= r1(i) 且 r2(i) ~= r0(i)
%
% Call:
%    [r1 r2 ...] = gnA1A2(NP1)   % r0 is set to be (1:NP1)'
%    [r1 r2 ...] = gnA1A2(NP1, r0) % r0 should be of length NP1
%
% Version: 2.1  Date: 2008/07/01
% Written by Jingqiao Zhang (jingqiao@gmail.com)

NP0 = length(r0);

r1 = floor(rand(1, NP0) * NP1) + 1;
for i = 1 : 1001
    pos = (r1 == r0);
    % 如果 r1 和 r0 完全相异则跳出
    if sum(pos) == 0
        break;
    % 重新生成重复元素
    else
        r1(pos) = floor(rand(1, sum(pos)) * NP1) + 1;
    end
    if i > 1000
        error('Can not genrate r1 in 1000 iterations');
    end
end

r2 = floor(rand(1, NP0) * NP2) + 1;
for i = 1 : 1001
    pos = ((r2 == r1) | (r2 == r0));
    % 如果 r2 和 r0, r1 完全相异则跳出
    if sum(pos)==0
        break;
    % 重新生成重复元素
    else
        r2(pos) = floor(rand(1, sum(pos)) * NP2) + 1;
    end
    if i > 1000
        error('Can not genrate r2 in 1000 iterations');
    end
end
