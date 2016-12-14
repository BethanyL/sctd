function [recon,omegat,U] =  DMD(X, time, svTol)
% DMD algorithm

% might want to have default of svTol = 1 (don't truncate singular values)



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

