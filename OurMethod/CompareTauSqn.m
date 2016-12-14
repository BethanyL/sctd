function bic_sqn = CompareTauSqn(tauopts, Y, R, D, init, npq, decompfn, nD)

    bic_sqn = zeros(length(tauopts),1);
    for t = 1:length(tauopts)
        tau = tauopts(t);
        [Ahat,Bhat,Zhat,lambdahat,~] = decompfn(Y, R, D, tau, init, nD);
        if ~isnan(lambdahat)
            bic_sqn(t) = bic(Y - tensor(ktensor(lambdahat,Ahat,Bhat,D*Zhat)),...
            Zhat, npq);
        else
            bic_sqn(t) = Inf;
        end
    end


end

