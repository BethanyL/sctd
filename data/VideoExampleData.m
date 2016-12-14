function [xbar, ktensorVersion] = VideoExampleData(backflag, plotflag)
% video stream mrDMD example from "Multi-Resolution Dynamic Mode
% Decomposition paper" Figures 3 & 4, Section 4.1

% plotflag = 1: show some frames
% backflag = 1: add in background

% 4 spatio-temporal modes combined \bar{\Psi}_j
% time dynamics a_j(t) 
% true solution \bar{x} = \sum_{j=1}^4 a_j(t) \bar{\Psi}_j(x,y)


xvals = -50:1:50;
xNum = length(xvals);
yvals = -50:1:50;
yNum = length(yvals);
[Xgrid,Ygrid] = meshgrid(xvals,yvals);

% generate background 
Psi1fn = @(x,y) 0.1*exp(sin(-x.^2-y.^2));
a1 = @(t) ones(size(t));

sigma = 0.1;
ic2 = [-25, 25];
Psi2fn = @(x,y) exp(-sigma*(x-ic2(1)).^2 - sigma*(y-ic2(2)).^2);
a2 = @(t) 2*cos(t*(2*pi)/64);

ic3 = [25, -25];
Psi3fn = @(x,y) exp(-sigma/5*(x-ic3(1)).^2 - sigma/2*(y-ic3(2)).^2);
a3 = @(t) 2*shannonfn(t,64,32)' .* sin(t*(2*pi)/16);

ic4a = [-10,0];
ic4b = [10,0];
Psi4afn = @(x,y) exp(-sigma/2*(x-ic4a(1)).^2 - sigma/4*(y-ic4a(2)).^2);
Psi4bfn = @(x,y) exp(-sigma/2*(x-ic4b(1)).^2 - sigma/4*(y-ic4b(2)).^2);
Psi4fn = @(x,y) Psi4afn(x,y) + Psi4bfn(x,y);
a4 = @(t) 2*shannonfn(t,32,80)' .* sin(t*(2*pi)/8);

time = 0:1:128;

if plotflag
    figure(1)
    subplot(2,2,1), plot(time,a1(time)), xlim([0,128])
    subplot(2,2,2), plot(time,a2(time)), xlim([0,128])
    subplot(2,2,3), plot(time,a3(time)), xlim([0,128])
    subplot(2,2,4), plot(time,a4(time)), xlim([0,128])
end

Psi1 = Psi1fn(Xgrid,Ygrid);
Psi2 = Psi2fn(Xgrid,Ygrid);
Psi3 = Psi3fn(Xgrid,Ygrid);
Psi4 = Psi4fn(Xgrid,Ygrid);

if plotflag
    figure(2)
    subplot(2,2,1), imagesc(flip(Psi1)), colormap(hot), caxis([0,1])
    subplot(2,2,2), imagesc(flip(Psi2))
    subplot(2,2,3), imagesc(flip(Psi3))
    subplot(2,2,4), imagesc(flip(Psi4))
end

% K = ktensor(lambda,U1,U2,...,UM) creates a Kruskal tensor from its
%     constituent parts. Here lambda is a k-vector and each Um is a
%     matrix with k columns.

[U,S,V] = svd(Psi2);
A = zeros(size(U,1), 3);
B = zeros(size(V,1), 3);
C = zeros(length(time), 3);
lambda = zeros(3,1);
lambda(1) = S(1,1);
A(:,1) = U(:,1);
B(:,1) = V(:,1); 
C(:,1) = a2(time);

[U,S,V] = svd(Psi3);
lambda(2) = S(1,1);
A(:,2) = U(:,1);
B(:,2) = V(:,1); 
C(:,2) = a3(time);

[U,S,V] = svd(Psi4);
lambda(3) = S(1,1);
A(:,3) = U(:,1);
B(:,3) = V(:,1); 
C(:,3) = a4(time);

ktensorVersion = ktensor(lambda, A, B, C);

if backflag
    fprintf('For now, ktensorVersion does not include background because higher rank\n')
end

% Psi1, ... produce grid/image
% want third (/fourth) dimension of time
xbar = zeros(yNum, xNum, length(time));
for j = 1:length(time)
    t = time(j);
    xbar(:,:,j) = a2(t) * Psi2 + a3(t) * Psi3 + ...
        a4(t) * Psi4;
    if backflag
        xbar(:,:,j) = xbar(:,:,j) + a1(t) * Psi1;
    end
end

if plotflag
    for j = round(linspace(1,length(time),10))
        figure(j+2)
        imagesc(flip(xbar(:,:,j))), colormap(hot), caxis([0,1])
        colorbar
    end
end
