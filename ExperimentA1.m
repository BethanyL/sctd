load('BaseParams.mat')

time = 0:1:128;

dictfn = @(numModes) SinCosWindowedDictEven(numModes, time);
dataname = 'Figure5Data';

% note: no noisefn because already added noise (so that exactly same across
% methods)

max_iter = 12; % for the sake of Figure6

numTrials = 1;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);
sparsities = zeros(numTrials, 1);


numModes = 40000;
expnum = 'A1';
    
for t = 1:numTrials
    [errors(t), corrs(t), sparsities(t)] = BaseExperiment(decompfn, dictfn, dataname, initfnA, ...
    initfnB, initfnZ, noisefn, numModes, Zthresholdfn, max_iter, lowtau, ...
    hightau, perturbAfn, perturbBfn, perturbZfn, expnum, t, ...
    lenSqn, slopeThreshold, diffThreshold);
end

csvwrite(sprintf('./exp%s/summary.csv',expnum),[errors, corrs, sparsities])



    