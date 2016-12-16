function [recon,omegat,U] =  DMD(X, time, svTol)
% DMD algorithm
%
% INPUTS:
% 
% X 
%       data matrix, where each column is a different time 
%
% time
%       vector of time points when the snapshots in the data were taken
%       (i.e. 1, 2, 3, ... for most videos)
%
% svTol
%       scalar in [0, 1]: tolerance for truncating singular value 
%       decomposition. This is the percentage of "energy" to keep: 
%       keep the singular values such that 
%       cumsum(diag(St))/sum(diag(St)) > svTol, where St is the
%       set of singular values maintained.
%
% OUTPUTS:
%
% recon
%       matrix, reconstruction of X using DMD 
%
% omegat
%       vector of frequencies omega
%
% U
%       matrix: left singular vectors 
%


deltat = time(2) - time(1);

[N,M] = size(X);
X1 = X(:,1:M-1);
X2 = X(:,2:M);

% take svd of X_1^M-1
[U,S,V] = svd(X1,0);
perc = cumsum(diag(S))/sum(diag(S));
K = find(perc > svTol,1);

% truncated SVD
Ut = U(:,1:K);
St = S(1:K,1:K);
Vt = V(:,1:K);

% compute Atilde: K x K projection of A onto the POD modes
Atildet = Ut' * X2 * Vt * St^(-1);

% compute eigendecomposition of Atilde
[Wt,Lt] = eig(Atildet);

omegat = log(diag(Lt))/deltat;


% % reconstruct eigendecompostion of A
VSWt = Vt * St^(-1) * Wt;
Phit = X2 * VSWt; % N x K


% approx soln for future
x1 = X(:,1); % initial snapshot at time 0
bt = pinv(Phit)*x1;
    

recon = zeros(N,length(time));

% reconstruct data 
for k = 1:length(time)
    recon(:,k) = Phit * diag(exp(omegat*time(k))) * bt;
end




    
end

