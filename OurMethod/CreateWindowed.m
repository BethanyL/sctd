function [windowDict, params] = CreateWindowed(dictOrig, time, widthList, shiftList)

% inputs: 
% dictOrig is a dictionary of modes
% time is a vector, i.e. 0:.1:10
% widthList is a vector of widths for windows: each window is tau +-
% width/2
% shiftList is a vector of the centers (tau) of the windows

% output:
% windowDict is copies of dictOrig but with windows applied. Note that this
% will not include the original dictionary.

numItems = size(dictOrig,2);
lenTime = length(time);
numWidths = length(widthList);
numShifts = length(shiftList);
numWindows = numWidths * numShifts;

windowDict = zeros(lenTime, numWindows * numItems);
params = zeros(numWindows * numItems, 3); 

count = 1;
  
for w = 1:numWidths
    width = widthList(w); 
    for s = 1:numShifts
        tau = shiftList(s);
        % shannon function returns 0s before and after the window,
        % 1 in the window
        % window is tau +- width/2
        filter = shannonfn(time,width,tau);
        windowDict(:,count:count+numItems-1) = dictOrig.*repmat(filter,1,numItems);
        params(count:count+numItems-1, 2) = width;
        params(count:count+numItems-1, 3) = tau;
        
        count = count + numItems;
    end
end



end

