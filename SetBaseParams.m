decompfn = @(X, R, D, tau, init, nD) cp_sparse(X, R, D, tau, init, nD);

time = 0:1:128;
dictfn = @(numModes) SinCosWindowedDict(numModes, time);

datafn = @() VideoExampleData(0,0);

initfnA = @(n, m) rand(n, m);
initfnB = @(n, m) rand(n, m);
initfnZ = @(n, m) rand(n, m);

noisefn = @(X) X;

%strength = .5;
%noisefn = @(X) WhiteGaussian(X, strength);

numModes = 50000;

Zthresholdfn = @(Zhat) Zhat;
%Zthresholdfn = @(Zhat) OnlyOneD(Zhat);

max_iter = 3;
lowtau = .005;
hightau = 2;

perturbAfn = @(Ahat) Ahat + 0.001*ones(size(Ahat));
perturbBfn = @(Bhat) Bhat + 0.001*ones(size(Bhat));
perturbZfn = @(Zhat) Zhat;

expnum = 1;

lenSqn = 20;

slopeThreshold = .1;
diffThreshold = 10^(-2);

svTol = .995;

numTrials = 5;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);
sparsities = zeros(numTrials, 1);

save('BaseParams.mat')


    