load('BaseParams.mat')

time = 0:1:128;

%   2nd mode: 2*cos(t*(2*pi)/64)
%   3rd mode: 2*sin(t*(2*pi)/16) (but only on first half of the time)
%   4th mode: 2*sin(t*(2*pi)/8) (but only on for third fourth of the time)
fixedParams = [(2*pi)/64, 128, 64, 1;...
(2*pi)/16, 64, 32, 0; ...
(2*pi)/8, 32, 80, 0];
dictfn = @(numModes) SinCosWindowedDictEven(numModes, time, fixedParams);

dataname = 'Figure4DataNoiseless.mat';

numTrials = 1;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);
sparsities = zeros(numTrials, 1);


numModes = 2800;
expnum = 'A2';
    
for t = 1:numTrials
    [errors(t), corrs(t), sparsities(t)] = BaseExperiment(decompfn, dictfn, dataname, initfnA, ...
    initfnB, initfnZ, noisefn, numModes, Zthresholdfn, max_iter, lowtau, ...
    hightau, perturbAfn, perturbBfn, perturbZfn, expnum, t, ...
    lenSqn, slopeThreshold, diffThreshold);
end

csvwrite(sprintf('./exp%s/summary.csv',expnum),[errors, corrs, sparsities])




    