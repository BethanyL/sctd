function Y = Reconstruct(lambda, A, B, D, Z)
% 
% assemble the Kruksal tensor decomposition that we've found (the reconstruction of the data)
%
% Each column of A, B, and D*Z belongs to a different term of the decomposition. 
% The terms are combined with coefficients lambda.

Y = zeros(size(A,1), size(B,1), size(D, 1)); 
R = size(A,2);
for j = 1:R
    Y = Y + tensor(ktensor(lambda(j),A(:,j),B(:,j),D*Z(:,j)));
end
