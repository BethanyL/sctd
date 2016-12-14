function Y = Reconstruct(lambda, A, B, D, Z)

Y = zeros(size(A,1), size(B,1), size(D, 1)); 
R = size(A,2);
for j = 1:R
    Y = Y + tensor(ktensor(lambda(j),A(:,j),B(:,j),D*Z(:,j)));
end
