function [dict, nD, params] = NOAAComboDictEven(numModes, tSpan)
% This function will make a dictionary that is used for
% the NOAA data. 
%
% INPUTS: 
%
% numModes: 
%       scalar: roughly how many prototypes do you want? It won't 
%       be exact in this version because of the way I'm rounding.
%
% tSpan: 
%       time range to define prototype on
%
% OUTPUTS:
%
% dict
%       matrix: library/dictionary (each column is a prototype)
%
% nD
%       scalar: number of prototypes in library/dictionary
%
% params
%       matrix: parameters, one row for each prototype
%       This enables us to later remember which element of the library 
%       corresponds to which analytical expression
%

numEach = round(numModes/2);
[dict1, nD1, params1] = SinCosWindowedDictEven(numEach, tSpan);
[dict2, nD2, params2] = GaussianDict(numEach, tSpan);

dict = [dict1 dict2];
nD = nD1 + nD2;
% last column is which dictionary it came from
% pad params2 with extra column to fit with params1
params = [params1, ones(nD1, 1); params2, 2*ones(nD2, 3)];

end

