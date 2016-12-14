load('BaseParams.mat')

expnum = 'B1';
dataname = 'Figure5Data';
R = 3;
decompfn = @(data, R) cp_als(data, R); 

% note: no noisefn because already added noise (so that exactly same across
% methods)

numTrials = 1;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);

for t = 1:numTrials
    [errors(t), corrs(t)] = BaseTTExperiment(decompfn, ...
        dataname, noisefn, R, expnum, t);
end

csvwrite(sprintf('./exp%s/summary.csv',expnum),[errors, corrs])