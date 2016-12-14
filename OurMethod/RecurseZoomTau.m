function tauopts2 = RecurseZoomTau(tauopts, Y, R, D, init, npq, decompfn, nD, oldtau, lenSqn, slopeThreshold, diffThreshold, count)
% recursively zoom in to pick best regularization parameter tau
% called by PickBestTau.m after creating initial list of tau options
% (also recursively calls self)
%
% INPUTS:
%
% tauopts
%           vector of tau options under consideration. This list changes as
%           we recurse. 
%
% Y, R, D, init, npq, decompfn, nD, oldtau, lenSqn, slopeThreshold, 
% diffThreshold
%           see PickBestTau.m: just passing paramters along
% 
% count
%           track number of times we've recursed, so don't recurse for too
%           long 
%
% OUTPUT:
%
% tauopts2
%           new vector of tau options
%

    % find which tau value minimizes the BIC criteria
    bic_sqn = CompareTauSqn(tauopts, Y, R, D, init, npq, decompfn, nD);
    [val, ind] = min(bic_sqn);
    
    % only need one value of tau, so if there's a tie, pick the biggest
    % (most sparsity)
    ind = ind(end); 
    
    % sometimes BIC value is Inf because tau is too big (too much 
    % sparsity enforced) and Z becomes all zeros (meaning that, once
    % multiplied out, the whole tensor term is all zeros)
    
    % if going below oldtau, pick biggest non-NaN option
    if tauopts(ind) < oldtau 
        ind = find(bic_sqn < Inf, 1, 'last');
        val = bic_sqn(ind);
    end
    
    if val < Inf
        % found some tau options that are not too big!
        if ind == 1
            % smallest option was ok (no NaN) but best - still try to be at
            % least as big as oldtau, so zoom in again between first entry
            % and second entry 
            tauopts2 = linspace(tauopts(ind), tauopts(ind+1), lenSqn);
        elseif ind == length(bic_sqn)
            % then can't pick next biggest, so add another option on to the
            % end and search in neighborhood
            deltatau = tauopts(ind)-tauopts(ind-1);
            fprintf('might want to increase hightau: picked %.2f\n',tauopts(ind))
            tauopts2 = linspace(tauopts(ind-1), tauopts(ind)+deltatau, lenSqn);
        else 
            % normal case: search in neighborhood of current best 
            tauopts2 = linspace(tauopts(ind-1), tauopts(ind+1), lenSqn);
        end
    else
        % all taus too big, so carefully try some smaller ones 
        tauopts2 = FindBiggestTau(tauopts, Y, R, D, init, npq, lenSqn, decompfn, nD);
    end
    
    % check if done or need to zoom again 
    [tau, ind, maxslope, maxdiff] = PickTauFromList(tauopts2, Y, R, D, init, npq, decompfn, nD, oldtau);
    
    % check if slope of BIC curve near tau is sufficiently flat
    % if not flat AND neighboring taus aren't already super close, zoom in
    % again
    if (maxdiff > diffThreshold) && (maxslope > slopeThreshold) 
        if count < 50
            fprintf('Currently at tau = %.2f. Neighbors have slope of %.2f, so recurse\n',tau,maxslope)
            tauopts2 = RecurseZoomTau(tauopts2, Y, R, D, init, npq, decompfn, nD, oldtau, lenSqn, slopeThreshold, diffThreshold, count+1);
        end
        % else, stop zooming
    end


end

