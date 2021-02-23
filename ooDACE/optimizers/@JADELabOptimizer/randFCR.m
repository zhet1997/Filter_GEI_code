function [F,CR] = randFCR(NP, CRm, CRsigma, Fm,  Fsigma)

% 使用均值为 CRm 标准差为 CRsigma 的正态分布生成 CR, 截断至 [0,1]
% 使用均值为 Fm 标准差为 Fsigma 的柯西分布生成 F, 截断至 [0,1]

%% 生成 CR
CR = CRm + CRsigma * randn(NP, 1);
CR = min(1, max(0, CR));

%% 生成 F
F = randCauchy(NP, 1, Fm, Fsigma);
F = min(1, F);                          % truncation

% 当 F<=0, 重新生成
pos = find(F <= 0);
while ~ isempty(pos)
    F(pos) = randCauchy(length(pos), 1, Fm, Fsigma);
    F = min(1, F);                      % truncation
    pos = find(F <= 0);
end

% 柯西分布: cauchypdf = @(x, mu, delta) 1/pi*delta./((x-mu).^2+delta^2)
function result = randCauchy(m, n, mu, delta)

% http://en.wikipedia.org/wiki/Cauchy_distribution
result = mu + delta * tan(pi * (rand(m, n) - 0.5));
