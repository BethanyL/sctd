function bic_sqn = CompareTauSqn(tauopts, Y, R, D, init, npq, decompfn, nD)
% given a sequence of options for tau (the regularization parameter), return
% the BIC for each tau value
%
% INPUTS:
%
% tauopts
%       vector of options for tau
%
% Y
%       current tensor remaining to decompose (we subtract off the previous
%       terms at each iteration)
%
% R
%       scalar: number of decomposition terms to find in this iteration
%       (we use R = 1 in our paper)
%
% D
%       matrix: library/dictionary (each column is a prototype)
%
% init
%       cell array of length 3 containing 3 vectors: initial values for
%       A, B, and Z
%
% npq
%       scalar: n*p*q where n, p, and q are the dimensions of the data
%
% decompfn
%       function that computes decomposition (see more in BaseExperiment.m)
%
% nD
%       scalar: number of prototypes in library/dictionary
%
% OUTPUTS:
%
% bic_sqn
%       vector: the BIC for each tau option
%

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

