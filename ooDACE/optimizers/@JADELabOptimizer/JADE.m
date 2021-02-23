function [bestind,bestvalue]=JADE(FUN, n,lu,iters)
%���Ϊ�������������ֵ
%FUNΪĿ�꺯������������
%nΪ������ά��
%luΪ�½���Ͻ�
%itersΪ����������
        
        % ��Ⱥ��ģ
        popsize = 100;

       % ��ʼ����, popsize * n����
        popold = repmat(lu(1, :), popsize, 1) + rand(popsize, n) .* (repmat(lu(2, :) - lu(1, :), popsize, 1));
        
        %��Ӧ�Ⱥ���
        for i=1:popsize
              valParents(i,:)=FUN(popold(i,:));
        end
        
        % ����Ӧ�����Ŀ��Ʋ���
        c = 1/10;
        
        % ��������о�Ӣ�����Ŀ��Ʋ���
        p = 0.05;
        
        % ������� �������ӳ�ʼֵ??
        CRm = 0.5;
        Fm = 0.5;

        % �����浵����Դ�С
        Afactor = 1;

        archive.NP = Afactor * popsize;    % �浵��ģ
        archive.pop = zeros(0, n);              % �浵����
        archive.funvalues = zeros(0, 1);  % ��Ӧ��

       %% �c�Ž��?Ӧ�Ⱥͱ��, ����
        [valBest, indBest] = sort(valParents, 'ascend');

       % ������������
        FES = 0;


       while FES <iters
            
           % ���ƾ���Ⱥ����ǰ��Ⱥ
            pop = popold;

            if FES > 1 && ~isempty(goodCR) && sum(goodF) > 0          % 如果 goodF and goodCR 是空�?, 暂不更新均�??
                CRm = (1 - c) * CRm + c * mean(goodCR);
                Fm = (1 - c) * Fm + c * sum(goodF .^ 2) / sum(goodF); % Lehmer 平均
            end

           % �þ��� CRm, ��׼��Ϊ 0.1 ����̬�ֲ����� CR
            % �þ��� Fm, ��׼��Ϊ 0.1 ����̬�ֲ����� CR
            % ��Ϊ popsize * 1 ����, ��ÿ�����岻��, ��ͬد���岻ͬά����ͬ
            [F, CR] = randFCR(popsize, CRm, 0.1, Fm, 0.1);

            % ������������� popsize ά������, ��Ϊ���
            r0 = [1 : popsize];
            popAll = [pop; archive.pop];
            [r1, r2] = gnR1R2(popsize, size(popAll, 1), r0);
            

           % Ѱ�� p-best 
            pNP = max(round(p * popsize), 2);                 % �������� 2��
            randindex = ceil(rand(1, popsize) * pNP); %% �� [1, 2, 3, ..., pNP] �����?��, n ά������
            randindex = max(1, randindex);                     % 0 ��Ϊ 1
            pbest = pop(indBest(randindex), :);       

            % ����
            vi = pop + F(:, ones(1, n)) .* (pbest - pop + pop(r1, :) - popAll(r2, :));
            vi = boundConstraint(vi, pop, lu);

             % ����
            mask = rand(popsize, n) > CR(:, ones(1, n));                                   % �����ж� ui ��ЩԪ�����Ը���
            rows = (1 : popsize)'; cols = floor(rand(popsize, 1) * n)+1;       % ÿ���������, �����Ը���
            jrand = sub2ind([popsize n], rows, cols); mask(jrand) = false;
            ui = vi; ui(mask) = pop(mask);
        
            % ��Ӧ�Ⱥ���
            for i=1:popsize
                  valOffspring(i,:)=FUN(ui(i,:));
            end
            
           % ������������
            FES = FES + popsize;

            % ѡ��
            % I == 1: ��������; I == 2: �Ӵ�����
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