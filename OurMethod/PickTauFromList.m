function [tau, ind, maxslope, maxdiff] = PickTauFromList(tauopts, Y, R, D, init, npq, decompfn, nD, oldtau)
%
% have list of tau options, pick the best one (no recursion or creating any other tau options - restricted
% to ONLY this list)
% called by PickBestTau.m and RecurseZoomTau.m 
% for explanation of inputs and context, see PickBestTau.m or RecurseZoomTau.m
%
% OUTPUTS:
%
% tau
%       scalar: chosen regularization parameter
%
% ind
%       index of tauopts where tau was found
%
% maxslope
%       scalar: how much (in abs value) does BIC fn change in neighborhood of tau? (If big change,
%       might want to zoom in further to investigate neighbors)
%
% maxdiff
%       what's the farthest that tau's neighbors are? (If close, don't want to zoom in further)
%

    bic_sqn = CompareTauSqn(tauopts, Y, R, D, init, npq, decompfn, nD);
    [val, ind] = min(bic_sqn);
    ind = ind(end);
    
    if tauopts(ind) < oldtau
        % if going below oldtau, pick biggest non-NaN option
        ind = find(bic_sqn < Inf, 1, 'last');
        val = bic_sqn(ind);
    end

    tau = tauopts(ind);
    slope = [];
    
    if ind > 1
        indLeft = ind-1;
        slope(1) = abs(bic_sqn(indLeft) - bic_sqn(ind)) /...
        abs(tauopts(indLeft)-tauopts(ind));
    else
        indLeft = ind;
    end
    if ind < length(tauopts)
        indRight = ind+1;
        slope = [slope, abs(bic_sqn(indRight) - bic_sqn(ind)) /...
        abs(tauopts(indRight)-tauopts(ind))];
    else
        indRight = ind;
    end
    
    %neighbors = [bic_sqn(indLeft), bic_sqn(ind), bic_sqn(indRight)];
            
    % slope: how much (in abs value) does BIC fn change in neighborhood of tau? 
    % bic is function of tau 

    
    maxslope = max(slope);
    maxdiff = max(tauopts(ind)-tauopts(indLeft), tauopts(indRight) - tauopts(ind));

end

