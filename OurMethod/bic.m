function val = bic(update, Z, npq)

% tensor toolbox will use its version of norm for a tensor, which is
% **frobenius**
val = log(norm(update)^2/npq) + log(npq)/npq * nnz(Z); 

end

