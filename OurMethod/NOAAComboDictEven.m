function [dict, nD, params] = NOAAComboDictEven(numModes, tSpan)

numEach = round(numModes/2);
[dict1, nD1, params1] = SinCosWindowedDictEven(numEach, tSpan);
[dict2, nD2, params2] = GaussianDict(numEach, tSpan);

dict = [dict1 dict2];
nD = nD1 + nD2;
% last column is which dictionary it came from
% pad params2 with extra column to fit with params1
params = [params1, ones(nD1, 1); params2, 2*ones(nD2, 3)];

end

