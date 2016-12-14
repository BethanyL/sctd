function [dict, nD, params] = CosDictWrap(numModes, tSpan)

% This function will make a dictionary that is used as part of the crime data dictionary

% input: 
% numModes: roughly how many columns do you want?
%   won't be exact in this version because of the way I'm rounding
% tSpan: time range to evaluate on

% output:
% dictionary (each column is a mode)
deltat = tSpan(2)-tSpan(1);

% want original to be cos(x) shifted up and squished: (1/2)cos(x)+1
% but only in window from -pi to pi
% cos(ax) has period 2pi/a, so want window from -pi/a to pi/a
% cos(a(x+b)) shifts right by b
cosfn = @(x,a,b) (1/2)*(cos(a*(x-b))+1) .* shannonfn(x,(2*pi)/a,b)';
cosSumfn = @(x,a,b) cosfn(x,a,b) + cosfn(x+tSpan(end),a,b) + cosfn(x-tSpan(end),a,b);
% width (2*pi)/a
% centered at tau = b

% Combination roughly equal of
% numbers of A values vs. B values
% numModes = numAs * numBs
numAs = round(sqrt(numModes-1));
numBs = round((numModes-1) / numAs);

% width = (2*pi)/a
widthMin = deltat;
widthMax = tSpan(end);
widthList = linspace(widthMin,widthMax,numAs);

% pick evenly spaced a values
aList = (2*pi)./widthList;

% centered throughout interval
bList = linspace(tSpan(1), tSpan(end), numBs);


nD = numAs * numBs + 1; 
dict = zeros(length(tSpan), nD);
params = zeros(nD, 2);
count = 1;
for j = 1:numAs
    for k = 1:numBs
        dict(:,count) = cosSumfn(tSpan,aList(j),bList(k));
        params(count, 1) = aList(j);
        params(count, 2) = bList(k);
        count = count + 1; 
    end
end
dict(:,count) = ones(length(tSpan),1);
params(count, 1) = 0;
params(count, 2) = Inf;

% Remove columns that are all zeros
ix0 = [];
for j = 1:nD
    if nnz(dict(:,j)) == 0
        ix0 = [ix0, j];
    end
end
dict = dict(:,setdiff(1:nD,ix0));
params = params(setdiff(1:nD,ix0),:);
nD = size(dict,2);

% Normalize the dictionary components
for i = 1:nD
   dict(:,i) = dict(:,i)./norm(dict(:,i)); 
end


end

