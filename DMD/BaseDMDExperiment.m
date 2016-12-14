% core for calling DMD
function error = BaseDMDExperiment(dataname, noisefn, expnum, trialnum, svTol, time)

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
