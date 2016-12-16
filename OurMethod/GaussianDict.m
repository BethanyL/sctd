function [dict, nD, params] = GaussianDict(numModes, tSpan)
% This function will make a dictionary that is used as part of the crime data 
% and NOAA dictionaries. Each element is a Gaussian. 
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

gaussfn = @(x,mu,sigma) (1/(sigma*sqrt(2*pi))) * exp(-(x-mu).^2/(2*sigma^2));


% combination roughly equal of
% numbers of mu values vs. sigma values
% numModes = numMus * numSigmas
numMus = round(sqrt(numModes));
numSigmas = round(numModes / numMus);


muMin = tSpan(1);
muMax = tSpan(end);
% pick evenly spaced mu values
muList = linspace(muMin, muMax, numMus);
% want to go up to gaussian large on whole space (2*sigma = span)
sigmaList = linspace(-1, (muMax-muMin)/2, numSigmas);

nD = numMus * numSigmas; 
dict = zeros(length(tSpan), nD);
params = zeros(nD, 2);
count = 1;
for j = 1:numMus
    for k = 1:numSigmas
        dict(:,count) = gaussfn(tSpan,muList(j),sigmaList(k));
        params(count, 1) = muList(j);
        params(count, 2) = sigmaList(k);
        count = count + 1; 
    end
end

% Normalize the dictionary components
for i = 1:nD
   dict(:,i) = dict(:,i)./norm(dict(:,i)); 
end


end

