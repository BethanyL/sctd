function [dict, nD, params] = SinCosWindowedDictEven(numModes, time, ...
    fixedParams)

rng(1); 

if nargin < 3
    fixedParams = [];
end

% Only using real modes (sines and cosines)

% input: 
% numModes: roughly how many columns do you want?
%   won't be exact in this version because of the way I'm rounding

% output:
% dictionary (each column is a mode)

% combination roughly equal of
% numbers of omega values vs. number of windows
% divide by two because we'll have sine and cosine
% include unwindowed modes (so + 1 below)
numOmegas = ceil(sqrt(numModes/2))+1;


dt = time(2) - time(1);


magnMax = 1;
% pick evenly spaced omegas from 0 to magnMax
omegaList = linspace(0, magnMax, numOmegas+1)';
omegaList = nonzeros(omegaList); % remove zeros because just
% zeros if do sin(0x) - add afterwards
omegaList = unique(omegaList);
numOmegas = length(omegaList);



dict = SinCosDict(time, omegaList);

nD = size(dict,2); 
params = zeros(nD, 4); 
for d = 2:2:nD
    params([d-1,d],1) = omegaList(d/2); % omega
    params(d-1,4) = 0; % sine
    params(d,4) = 1; % cosine 
end
params(:,2) = time(end); % width
params(:,3) = time(end)/2; % shift

% now add on a DC / constant one, which is same as cos(0*x)
dict = [dict ones(size(dict,1),1)];
params = [params; 0 time(end), time(end)/2, 1];
nD = nD + 1; 

numWindows = ceil(numModes / nD)+1; 


% now add windowed versions
% for now, try making number of widths and number of shifts roughly same
% however, don't want more widths than time points
numWidths = min([ceil(sqrt(numWindows)),length(time)])+1;
numShifts = ceil(numWindows / numWidths)+1;


% range from width of only one time point to all but one
minWidth = 2*dt;
maxWidth = time(end) - dt; 
widthList = linspace(minWidth,maxWidth,numWidths)';
widthList = unique(widthList);
numWidths = length(widthList);

% range from shifting by 0 to shifting to end
% recall that these shifts are middle of window 
minShift = 0;
maxShift = time(end);
shiftList = linspace(minShift,maxShift,numShifts)';

shiftList = unique(shiftList);
numShifts = length(shiftList);

[windowDict, ws] = CreateWindowed(dict, time, widthList, shiftList);
dict = [dict windowDict];


params = [params; repmat(params, numWidths*numShifts, 1)]; % gets the omegas right 
params(nD+1:end, 2:3) = ws(:,2:3);

nD = size(dict,2);



% Remove columns that are all zeros
ix0 = find(mean(dict,1) == 0);
dict = dict(:,setdiff(1:nD,ix0));
params = params(setdiff(1:nD,ix0),:);
nD = size(dict,2);

% Normalize the dictionary components
for i = 1:nD
   dict(:,i) = dict(:,i)./norm(dict(:,i)); 
end

[dict, ind] = unique(dict', 'rows');
dict = dict';
params = params(ind,:);
nD = size(dict,2);

numFixed = size(fixedParams,1);
if nD > numModes-numFixed
    % randomly pick some to keep 
    keepInd = randperm(nD, numModes-numFixed);
    dict = dict(:,keepInd);
    params = params(keepInd, :);
end
nD = size(dict,2);

% add on reqested params 
for j = 1:numFixed;
    elem = SinCosDict(time, fixedParams(j, 1)); 
    if fixedParams(j,4) == 0
        % sine
        elem = elem(:,1);
    else
        % cosine
        elem = elem(:,2); 
    end
    elem = CreateWindowed(elem, time, fixedParams(j,2), fixedParams(j,3));
    dict = [dict elem];
end
nD = size(dict,2);
params = [params; fixedParams];

end

