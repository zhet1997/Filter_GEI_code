function [bestind,bestvalue]=JADE(FUN, n,lu,iters)
%输出为最优坐标和最优值
%FUN为目标函数的匿名函数
%n为样本的维度
%lu为下界和上界
%iters为最大迭代次数
        
        % 种群规模
        popsize = 100;

       % 初始化种, popsize * n矩阵
        popold = repmat(lu(1, :), popsize, 1) + rand(popsize, n) .* (repmat(lu(2, :) - lu(1, :), popsize, 1));
        
        %适应度函数
        for i=1:popsize
              valParents(i,:)=FUN(popold(i,:));
        end
        
        % 自适应调整的控制参数
        c = 1/10;
        
        % 变异策略中精英比例的控制参数
        p = 0.05;
        
        % 交叉概率 变异因子初始值??
        CRm = 0.5;
        Fm = 0.5;

        % 差个体存档的相对大小
        Afactor = 1;

        archive.NP = Afactor * popsize;    % 存档规模
        archive.pop = zeros(0, n);              % 存档个体
        archive.funvalues = zeros(0, 1);  % 适应度

       %% 朿优解的?应度和标号, 降序
        [valBest, indBest] = sort(valParents, 'ascend');

       % 函数评估次数
        FES = 0;


       while FES <iters
            
           % 复制旧种群到当前种群
            pop = popold;

            if FES > 1 && ~isempty(goodCR) && sum(goodF) > 0          % 濡傛灉 goodF and goodCR 鏄┖鐨?, 鏆備笉鏇存柊鍧囧??
                CRm = (1 - c) * CRm + c * mean(goodCR);
                Fm = (1 - c) * Fm + c * sum(goodF .^ 2) / sum(goodF); % Lehmer 骞冲潎
            end

           % 用均倿 CRm, 标准差为 0.1 的正态分布生房 CR
            % 用均倿 Fm, 标准差为 0.1 的正态分布更斿 CR
            % 均为 popsize * 1 向量, 对每个个体不吿, 但同丿个体不同维度相同
            [F, CR] = randFCR(popsize, CRm, 0.1, Fm, 0.1);

            % 构造三个相异的 popsize 维列向量, 作为标号
            r0 = [1 : popsize];
            popAll = [pop; archive.pop];
            [r1, r2] = gnR1R2(popsize, size(popAll, 1), r0);
            

           % 寻找 p-best 
            pNP = max(round(p * popsize), 2);                 % 个数至少 2个
            randindex = ceil(rand(1, popsize) * pNP); %% 仿 [1, 2, 3, ..., pNP] 中随机?择, n 维列向量
            randindex = max(1, randindex);                     % 0 改为 1
            pbest = pop(indBest(randindex), :);       

            % 变异
            vi = pop + F(:, ones(1, n)) .* (pbest - pop + pop(r1, :) - popAll(r2, :));
            vi = boundConstraint(vi, pop, lu);

             % 交叉
            mask = rand(popsize, n) > CR(:, ones(1, n));                                   % 用来判断 ui 哪些元素来自父代
            rows = (1 : popsize)'; cols = floor(rand(popsize, 1) * n)+1;       % 每个个体随机, 不来自父代
            jrand = sub2ind([popsize n], rows, cols); mask(jrand) = false;
            ui = vi; ui(mask) = pop(mask);
        
            % 适应度函数
            for i=1:popsize
                  valOffspring(i,:)=FUN(ui(i,:));
            end
            
           % 更新评估次数
            FES = FES + popsize;

            % 选择
            % I == 1: 父代更优; I == 2: 子代更优
            [valParents, I] = min([valParents, valOffspring], [], 2);
            popold = pop;

            archive = updateArchive(archive, popold(I == 2, :), valParents(I == 2));

            popold(I == 2, :) = ui(I == 2, :);

            goodCR = CR(I == 2);
            goodF = F(I == 2);

            [valBest, indBest] = sort(valParents, 'ascend');
            
            bestind=popold(indBest(1),:);
            bestvalue=valBest;

        end
            
end