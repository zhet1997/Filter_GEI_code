%2019-8-20
%��������������override
%��F��ʾ�;��ȵ�����ֵ
%��alpha������beta0��ֵ
%�������ಿ�ֵ��޸ľͻ�Ƚ��١�
%>	[this err dsigma2] = updateRegression( this, F, hp )
%
% ======================================================================
%> Updates regression part of the model
% ======================================================================
function [this, err, dsigma2] = updateRegression( this, F, hp )%�����F��ָʲô������

	err = [];
       
    %> @todo Rho is only used by co-kriging, can we abstract this somehow ?
    % if using co-kriging calculate values{1} - rho*values{2}
    if this.optimIdx(1,this.RHO) && size(this.values,2) > 1  %��һ�����һ��˵����cokriging
        assert( ~isinf( hp{:,this.RHO} ) );%���Ժ���������ȷ��ĳ�����������������ټ�������
        
        values2 = this.values(:,2);
        
        this.rho = hp{:,this.RHO};
        this.values = this.values(:,1) - this.rho.*this.values(:,2);
    end
	
    %% Get least squares solution

    % decorrelation transformation:
    % Yt - Ft*coeff = inv(C)Y - inv(C)F*coeff
    % so Ft = inv(C)F <=> C Ft = F -> solve for Ft

	% Forward substitution
	Ft = this.C \ F(this.P,:); % T1  %����c��һ�������Ǿ���
                                     %c������R�������ǣ�����������ͬ��
                                     %Ft=inv(C)*F
                                     %C����ؾ�����ǿ�˹���ֽ�
                                     
    %F����������ع������ϵ������universal kriging�л��õ���
    % Bayesian Linear regression:
    %tmp = inv(this.F'*this.F + A)*(this.F'*this.F * betaPrior + A*betaPriorMean

    % Ft can now be ill-conditioned -> QR factorisation of Ft = QR
    [Q, R] = qr(Ft,0);    %QR�ֽ�
    if  rcond(R) < 1e-10  %����R��������
		% Check F
		err = 'F/Ft is ill-conditioned.';
		return;
    end

    % Now we know Ft is good, compute Yt
    % so Yt = inv(C)Y <=> C Yt = Y -> solve for Yt
    Yt = this.C \ this.values(this.P,:);
	
    % transformation is done, now fit it:
    % Q is unitary = orthogonal for real values -> inv(Q) = Q'
    %alpha = R \ (Q'*Yt); % polynomial coefficients%���alpha������Ҫ�Ļع���miu����bets
    alpha = (Ft'*Yt)/(Ft'*Ft);%�������ʵ���ϵ�Beta0��ֵ
    
	% residual2 = values(this.P,:) - this.F * alpha % simple
    % residual2 = C * residual; % take correlation into account for real variance
    % sigma2 = (residual' * T2) ./ n; % simple
    residual = Yt - Ft*alpha;  %��һ����ʱ������

    if this.optimIdx( 1, this.SIGMA2 )
        % take process variance from hyperparameters (stochastic kriging)
        this.sigma2 = 10.^hp{:,this.SIGMA2};
    else
        % compute process variance analytically    
        this.sigma2 = sum(residual.^2) ./ size(this.values, 1);
        
        % Reinterpolation of the prediction variance (Forrester2006)
        if this.options.reinterpolation
            tmp = (this.C*this.C') - this.Sigma;
            this.sigma2_reinterp = (residual' * tmp * residual) ./ size(this.values,1);
        end
    end
    
    % needed for derivatives for coKriging
    if nargout > 2 && this.optimIdx(1,this.RHO)%�ж��Ƿ�Ҫ���ݶ�
        dYt = this.C \ -values2;
        dalpha = R \ (Q'*dYt);
        dresidual = dYt - Ft*dalpha;
        
        %this.sigma2 = sum(residual.^2) ./ size(this.values, 1);
        dsigma2 = sum(2.*residual.*dresidual) ./ size(this.values, 1);
    else
        dsigma2 = [];
    end
    
    %% keep
    %�������һ���������ĸ�ֵ
	this.alpha = alpha;
	
	% inv(C11') * inv(C) * values or (inv(C)*residual)
	this.gamma = this.C(1:this.rank,1:this.rank)' \ residual;
	
	this.Ft = Ft;
	this.R = R;
