function [error, corr, sparsity] = BaseExperiment(decompfn, dictfn, dataname, initfnA, ...
    initfnB, initfnZ, noisefn, numModes, Zthresholdfn, max_iter, lowtau, ...
    hightau, perturbAfn, perturbBfn, perturbZfn, expnum, trialnum, ...
    lenSqn, slopeThreshold, diffThreshold)

% base experiment for testing SCTD algorithm
%
% INPUTS:
%
% decompfn
%           function that computes decomposition. Inputs should be: data to
%           decompose, number of components to extract, library, tau, 
%           initial guess, and size of library. Outputs should be
%           components of decomposition, weights lambda, and objective fn
%           values
%           this input allows experimenting with versions of cp_sparse.m 
%
% dictfn
%           function that creates library (dictionary). Input should be
%           number of prototypes desired in the library. Output should be
%           the library, the number of prototypes, and the parameters of
%           the prototypes
%
% dataname 
%           string for filename of mat file where data is stored as X
%
% initfnA
%           function that initializes first component of the decomposition,
%           A. Input should be the size of the first component and the 
%           number of iterations / terms in the decomposition. Output is 
%           initialized matrix for each iteration / term.
%
% initfnB
%           function like initfnA but for the second component, B
%
% initfnZ
%           function like initfnA but for the third component. Note:
%           the third compnonent C is D*Z, where D is the library. This 
%           initializes the coefficients Z.
%
% noisefn
%           function to add noise to the data. Input is the noiseless
%           data and output is the data with noise.
%
% numModes
%           scalar: number of prototypes requested for the library
%
% Zthresholdfn
%           function that optionally applies a thresholding to a vector 
%           of coefficients Z. Input is a vector and output is a vector
%           of the same size. Our default is not to threshold, so we pass
%           a function that returns its input unchanged.
%
% max_iter
%           scalar: number of terms to look for in the decomposition
%
% lowtau
%           scalar: when searching for regularization parameter tau, what
%           should be the default lower bound?
%
% hightau
%           scalar: when searching for regularization parameter tau, what
%           should be the default upper bound?
%
% perturbAfn
%           function that perturbs the current vector A to create 
%           new initialized value of A for the next iteration (next
%           term in the decomposition. Input is a vector and output is
%           another vector of the same size
%
% perturbBfn
%           like perturbAfn but for the second dimension, B
%
% perturbZfn
%           like perturbAfn but for the third dimension. Note:
%           the third compnonent C is D*Z, where D is the library. This 
%           initializes the coefficients Z.
%
% expnum
%           a string giving the experiment "number," such as "A1" - this 
%           determines the subdirectory where the results are saved
%
% trialnum
%           scalar: trial number within experiment (used for saving results
%           in appropriate subfolder of experiment)
%
% lenSqn
%           scalar: length of sequence of tau values to try at each level of
%           recursion
%
% slopeThreshold
%           scalar: threshold when choosing tau. If the objective function
%           is not flat enough in the neighborhood of the current best 
%           value of tau, "zoom in" on the neighborhood of tau to further
%           refine it
%
% diffThreshold
%           scalar: threshold when choosing tau. Only keep zooming in on
%           neighbors of tau if spacing between options is at least
%           diffThreshold
%
% OUTPUTS:
%
% error
%           scalar: relative reconstruction error of tensor decomposition
%
% corr
%           scalar: correlation between tensor decomposition and residual
%           (original data minus tensor decomposition)
%
% sparsity
%           scalar: number of non-zeros in Z (number of prototypes in
%           library that are actually used)
%
if nargin < 20
    diffThreshold = 10^(-2);
end

filedir = sprintf('./exp%s/trial%d/',expnum,trialnum);
mkdir(filedir)

load(dataname, 'X');
X = noisefn(X);

[D, nD, params] = dictfn(numModes);

% Normalize the dictionary components
for jj = 1:sum(nD)
    D(:,jj) = D(:,jj)./norm(D(:,jj)); 
end


tau_seq = zeros(max_iter, 1);
A = initfnA(size(X,1), max_iter);
B = initfnB(size(X,2), max_iter);
Z = initfnZ(sum(nD), max_iter);
lambda = zeros(max_iter,1);

R = 1;
Reconstruction = tenzeros(size(X));
Residual = tensor(X);
init = cell(3,1);
init{1} = A(:,1);
init{2} = B(:,1);
init{3} = Z(:,1);
 
npq = size(X,1) * size(X,2) * size(X,3);
oldtau = lowtau;

% objective: accuracy - tau * L1-norm: max accuracy, min L1
% higher the tau, more emphasis on sparsity

[tau_seq, A, B, Z, lambda, Residual, Reconstruction] = ourTensorDecomp(tau_seq, A, B, Z, lambda, max_iter, oldtau, lowtau, hightau, Reconstruction, R, D, init, ...
    npq, decompfn, lenSqn, nD, slopeThreshold, diffThreshold, Zthresholdfn,...
    Residual, perturbAfn, perturbBfn, perturbZfn);

error = norm(Reconstruction - X)/norm(tensor(X));
corr = innerprod(Reconstruction, Residual);
sparsity = nnz(Z);


csvwrite(strcat(filedir,'metrics.csv'),[error,corr,sparsity])
csvwrite(strcat(filedir,'D.csv'),D);
csvwrite(strcat(filedir,'tau_seq.csv'),tau_seq');
csvwrite(strcat(filedir,'lambda.csv'),lambda);
csvwrite(strcat(filedir,'A.csv'),A);
csvwrite(strcat(filedir,'B.csv'),B);
csvwrite(strcat(filedir,'Z.csv'),Z);
csvwrite(strcat(filedir,'X.csv'),X);
csvwrite(strcat(filedir,'params.csv'),params);
