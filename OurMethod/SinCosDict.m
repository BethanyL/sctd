function dict = SinCosDict(time, omegaList)
% This function will make a dictionary of sines and cosines (no windows)
%
% INPUTS: 
%
% time: 
%       time range to define prototype on
%
% omegaList:
%       vector of real #s: we create sin(omega*time), cos(omega*time)
%
% OUTPUTS:
%
% dict
%       matrix: library/dictionary (each column is a prototype)
%

numOmegas = length(omegaList);

dict = zeros(length(time), 2*numOmegas);

count = 1;
for j = 1:numOmegas
    omega = omegaList(j);
    dict(:,count) = sin(omega*time);
    dict(:,count+1) = cos(omega*time);
    count = count + 2;
end

end

