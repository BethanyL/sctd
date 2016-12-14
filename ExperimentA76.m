load('BaseParams.mat')

expnum = 'A76';
time = 0:1:23;

max_iter = 12;
numModes = 50000;
dictfn = @(numModes) CrimeComboDictEven(numModes,time);

dataname = 'HoustonCrime';

numTrials = 1;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);
sparsities = zeros(numTrials, 1);

for t = 1:numTrials
    [errors(t), corrs(t), sparsities(t)] = BaseExperiment(decompfn, dictfn, dataname, initfnA, ...
    initfnB, initfnZ, noisefn, numModes, Zthresholdfn, max_iter, lowtau, ...
    hightau, perturbAfn, perturbBfn, perturbZfn, expnum, t, ...
    lenSqn, slopeThreshold, diffThreshold);
end

csvwrite(sprintf('./exp%s/summary.csv',expnum),[errors, corrs, sparsities])