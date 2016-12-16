function val = bic(update, Z, npq)
%
% compute Bayesian Information Criterion (BIC)
% balances model fit and model complexity 
%
% INPUTS:
% 
% update 
%       residual tensor if use this value of tau
%
% Z
%       vector of coefficients where c_r = D*Z (so we can find
%       complexity of model by counting the number of non-zero entries)
%
% npq
%       scalar: n*p*q where n, p, and q are the dimensions of the data
%
% OUTPUT:
%
% val
%       scalar: value of BIC        

% tensor toolbox will use its version of norm for a tensor, which is
% **frobenius**
val = log(norm(update)^2/npq) + log(npq)/npq * nnz(Z); 

end

