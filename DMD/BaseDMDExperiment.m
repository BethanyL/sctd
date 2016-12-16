function error = BaseDMDExperiment(dataname, noisefn, expnum, trialnum, svTol, time)
% like BaseExperiment.m, but calls DMD.m instead of a tensor decomposition
%
% INPUTS:
% 
% dataname 
%       string for filename of mat file where data is stored as X
%
% noisefn
%       function that takes data as input and returns noisy version
%
% expnum
%       a string giving the experiment "number," such as "A1" - this 
%       determines the subdirectory where the results are saved
%
% trialnum
%       scalar: trial number within experiment (used for saving results
%       in appropriate subfolder of experiment)
%
% svTol
%       scalar in [0, 1]: tolerance for truncating singular value 
%       decomposition. This is the percentage of "energy" to keep: 
%       keep the singular values such that 
%       cumsum(diag(St))/sum(diag(St)) > svTol, where St is the
%       set of singular values maintained.
%
% time
%       vector of time points when the snapshots in the data were taken
%       (i.e. 1, 2, 3, ... for most videos)
%
% OUTPUTS:
%
% error 
%       scalar: reconstruction error 
% 

filedir = sprintf('./exp%s/trial%d/',expnum,trialnum);
mkdir(filedir)

load(dataname, 'X');
X = noisefn(X);

X = reshape(X, size(X,1) * size(X,2), size(X,3));


[recon,omegat,U] =  DMD(X, time, svTol);


save(strcat(filedir,'all.mat'))
csvwrite(strcat(filedir,'U.csv'),U);
csvwrite(strcat(filedir,'omega.csv'),omegat);

error = norm(recon - X);
