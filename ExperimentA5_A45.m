load('BaseParams.mat')

time = 0:1:128;
dictfn = @(numModes) SinCosWindowedDictEven(numModes, time);
dataname = 'Figure4DataNoiseless.mat';

numTrials = 1;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);
sparsities = zeros(numTrials, 1);

numModes = 50000;
strength = 0;
for j = 5:45
    expnum = sprintf('A%d',j);
    
    noisefn = @(X) WhiteGaussian(X, strength);

    
    for t = 1:numTrials
        [errors(t), corrs(t), sparsities(t)] = BaseExperiment(decompfn, dictfn, dataname, initfnA, ...
        initfnB, initfnZ, noisefn, numModes, Zthresholdfn, max_iter, lowtau, ...
        hightau, perturbAfn, perturbBfn, perturbZfn, expnum, t, ...
        lenSqn, slopeThreshold, diffThreshold);
    end

    csvwrite(sprintf('./exp%s/summary.csv',expnum),[errors, corrs, sparsities])
    strength = strength + .1; % 0:.1:4
end