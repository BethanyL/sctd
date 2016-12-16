function [A,B,Z,lambda,objs] = cp_sparse(X, R, D, tau, init, nD)
% Compute a CP decomposition that is sparse in one of its modes.
%
%   Computes an estimate of the best rank-R CP
%   model of a tensor X when one set of factors is approximated by a
%   sparse combination of dictionary elements. 
%
% INPUTS:
% 
% X
%           3-D data 
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
% tau
%           scalar: regularization parameter
%
% init
%           cell array of length 3 containing 3 vectors: initial values for
%           A, B, and Z           
%
% nD
%           number of prototypes in D
%
%
% OUTPUTS:
% 
% A, B, Z
%           decomposition matrices, where each has R columns 
%
% lambda
%           coefficients of decomposition: each of R terms is ktensor(lambda(r),a,b,D*z),
%           where a, b, and z are columns of A, B, and Z.
%
% obj
%           vector of values of objective function for each iteration
%

max_iter = 1e1;
tol = 1e-10;

%% Set up an initial guess for the factor matrices.
if iscell(init)
    % User provided an initial ktensor; validate it.

    if (length(init) ~= 3)
        error('Initial guess does not have the right number of modes');
    end
    
    A = init{1};
    B = init{2};
    Z = init{3};
    
elseif strcmp(init,'random')
    % Choose random values for each element in the range (0,1).
    A = rand(size(X,1),R);
    B = rand(size(X,2),R);
    Z = rand(nD,R);
end

objs = cell(R,1);

obj = zeros(max_iter,1);

MU = cell(3,1);

lambda = zeros(R,1);
Y = full(X);
for r = 1 : R
    a = A(:,r);
    b = B(:,r);
    z = Z(:,r);
    MU{1} = a/norm(a,'fro');
    MU{2} = b/norm(b,'fro');
    MU{3} = D*z/norm(z,'fro');
    nY = norm(Y);
    Y = mtimes(Y,1/nY);
    
    obj_last = innerprod(Y,ktensor(MU)) - tau*sum(sum(abs(z)));
    for iter = 1 : max_iter
        for iiter = 1 : 2
            % Update a
            a = mttkrp(Y, MU, 1);
            a = a/norm(a,'fro');
            MU{1} = a;
            % Update b
            b = mttkrp(Y, MU, 2);
            b = b/norm(b,'fro');
            MU{2} = b;
            % Update z
            f = mttkrp(Y, MU, 3);
            f = D'*f;
        end
        for j = 1 : nD
            z(j) = sign(f(j)) * max(abs(f(j)) - tau,0);
        end
        nz = norm(z,'fro');
        if nz > 0
            z = z/nz;
        end
        MU{3} = D*z;
        obj(iter) = innerprod(Y,ktensor(MU)) - tau*sum(sum(abs(z)));
        if obj(iter) - obj_last < tol*(abs(obj_last) + 1e-12)
            break
        end
        obj_last = obj(iter);
    end
    % Update lambda
    lambda(r) = nY*ttv(Y,{a,b,D*z})/norm(ktensor(MU))^2;
    A(:,r) = a;
    B(:,r) = b;
    Z(:,r) = z;
    Y = full(mtimes(nY,Y)) - full(ktensor(lambda(r),a,b,D*z));
    objs{r} = obj(1:iter);

end
end