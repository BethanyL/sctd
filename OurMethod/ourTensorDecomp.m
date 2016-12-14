function [tau_seq, A, B, Z, lambda, Residual, Reconstruction] = ourTensorDecomp(tau_seq, A, B, Z, lambda, max_iter, oldtau, lowtau, hightau, Reconstruction, R, D, init, npq, decompfn, lenSqn, nD, slopeThreshold, diffThreshold, Zthresholdfn, Residual, perturbAfn, perturbBfn, perturbZfn)
% wrapper function that does our tensor decomposition, one term in the
% decomposition at a time. Called by BaseExperiment.m
%
% INPUTS:
%
% tau_seq
%           vector of length max_iter (just need it initialized)
%
% A
%           matrix of size [m, max_iter] where m is the size of the first
%           dimension, a (just need it initialized)
%
% B
%           matrix of size [m, max_iter] where m is the size of the second
%           dimension, b (just need it initialized)
%
% Z
%           matrix of size [m, max_iter] where m is the number of 
%           prototypes in the library (just need it initialized)
%
% lambda
%           vector of length max_iter (just need it initialized)
%
% 
% max_iter
%           scalar: number of terms to look for in the decomposition
% 
% oldtau
%           scalar: we track tau from previous iteration (our default is to
%           initialize it to lowtau)
%
% lowtau
%           scalar: when searching for regularization parameter tau, what
%           should be the default lower bound?
%
% hightau
%           scalar: when searching for regularization parameter tau, what
%           should be the default upper bound?
%
% Reconstruction 
%           tensor of same size as original data, initialized to zeros
%
% R
%           scalar: number of terms of decomposition to search for at once 
%           (current algorithm only does 1 at a time)
%
% D
%           library (aka dictionary): matrix of size [m x nD], where m is 
%           the size of the third dimension, c, and nD is the number of 
%           prototypes in the library
%
% init
%           cell array of length 3 containing 3 vectors: initial values for
%           A, B, and Z
% npq
%           scalar: number of elements in original data (lengths of a, b, c
%           multiplied)
% 
% decompfn, lenSqn, nD, slopeThreshold, diffThreshold, Zthresholdfn, 
% perturbAfn, perturbBfn, perturbZfn
%           see BaseExperiment.m - just passing these inputs along 
%
% Residual
%           tensor form of original data 
%
% OUTPUTS
%
% tau_seq
%           update the input vector: regularization tau chosen for each
%           iteration / term in the decomposition 
%
% A, B, Z
%           update the input matrices: values chosen at each iteration /
%           term in the decomposition for the dimensions, a, b, and c
%           (C = D * Z, where D is the library)
%
% lambda
%           update the input vector: weights lambda for each
%           iteration / term in the decomposition 
%
% Residual
%           update the input tensor: orginal data minus the tensor
%           decomposition
%
% Reconstruction
%           update the input tensor with the tensor decomposition
%           calculated from A, B, D*Z, and lambda
%

for iter = 1:max_iter   
    
    tau = PickBestTau(oldtau, lowtau, hightau, Residual, R, D, init, npq, decompfn, lenSqn, nD, slopeThreshold, diffThreshold)
    tau_seq(iter) = tau;
    oldtau = tau;
    [Ahat,Bhat,Zhat,lambdahat,objs] = decompfn(Residual, R, D, tau, init, nD);

    Zhat = Zthresholdfn(Zhat);

    A(:,iter) = Ahat;
    B(:,iter) = Bhat;
    Z(:,iter) = Zhat;
    lambda(iter) = lambdahat;
    if isnan(lambdahat)
        keyboard
    end
    Reconstruction = Reconstruction + tensor(ktensor(lambdahat,Ahat,Bhat,D*Zhat));
    Residual = Residual - tensor(ktensor(lambdahat,Ahat,Bhat,D*Zhat));
    init{1} = perturbAfn(Ahat);
    init{2} = perturbBfn(Bhat);
    init{3} = perturbZfn(Zhat);
end

end

