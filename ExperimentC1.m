load('BaseParams.mat')

expnum = 'C1';
time = 0:1:128;
dataname = 'Figure5Data';
svTol = .99;

% note: no noisefn because already added noise (so that exactly same across
% methods)

numTrials = 1;
errors = zeros(numTrials, 1);
corrs = zeros(numTrials, 1);
sparsities = zeros(numTrials, 1);

for t = 1:numTrials
    errors(t) = BaseDMDExperiment(dataname, noisefn, expnum, t, svTol, time);

end

csvwrite(sprintf('./exp%s/summary.csv',expnum),errors)