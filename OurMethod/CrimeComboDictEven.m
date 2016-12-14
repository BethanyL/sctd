function [dict, nD, params] = CrimeComboDictEven(numModes, tSpan)

numEach = round(numModes/3);
[dict1, nD1, params1] = SinCosWindowedDictEven(numEach, tSpan);
[dict2, nD2, params2] = GaussianDict(numEach, tSpan);
[dict3, nD3, params3] = CosDictWrap(numModes, tSpan); 
dict = [dict1 dict2 dict3];
nD = nD1 + nD2 + nD3;
% last column is which dictionary it came from
% pad params2 and params3 with extra column to fit with params1
params = [params1, ones(nD1, 1); params2, 2*ones(nD2, 3); params3, 3*ones(nD3, 3)];

end

