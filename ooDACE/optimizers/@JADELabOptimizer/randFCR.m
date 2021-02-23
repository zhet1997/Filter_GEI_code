function [F,CR] = randFCR(NP, CRm, CRsigma, Fm,  Fsigma)

% ʹ�þ�ֵΪ CRm ��׼��Ϊ CRsigma ����̬�ֲ����� CR, �ض��� [0,1]
% ʹ�þ�ֵΪ Fm ��׼��Ϊ Fsigma �Ŀ����ֲ����� F, �ض��� [0,1]

%% ���� CR
CR = CRm + CRsigma * randn(NP, 1);
CR = min(1, max(0, CR));

%% ���� F
F = randCauchy(NP, 1, Fm, Fsigma);
F = min(1, F);                          % truncation

% �� F<=0, ��������
pos = find(F <= 0);
while ~ isempty(pos)
    F(pos) = randCauchy(length(pos), 1, Fm, Fsigma);
    F = min(1, F);                      % truncation
    pos = find(F <= 0);
end

% �����ֲ�: cauchypdf = @(x, mu, delta) 1/pi*delta./((x-mu).^2+delta^2)
function result = randCauchy(m, n, mu, delta)

% http://en.wikipedia.org/wiki/Cauchy_distribution
result = mu + delta * tan(pi * (rand(m, n) - 0.5));
