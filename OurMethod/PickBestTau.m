function tau = PickBestTau(oldtau, lowtau, hightau, Y, R, D, init, npq, decompfn, lenSqn, nD, slopeThreshold, diffThreshold)
% called by ourTensorDecomp.m to pick the best regularization parameter tau
% Recall: objective is accuracy - tau * L1-norm: max accuracy, min L1
% higher the tau, more emphasis on sparsity
%
% INPUTS:
% 
% oldtau
%           scalar: tau used in last iteration / term of decomposition
%           (would prefer that subsequent iterations have higher tau
%           than previous ones - we're accumulating error at each
%           iteration, so counteract by encouraging sparsity more)
%
% lowtau, hightau
%           scalars: prefer to pick taus in this range
%
% Y
%           tensor: data that is currently being decomposed (original data
%           minus terms of the decomposition that have already been
%           calculated)
% 
% R, D, init, npq, decompfn, nD
%
%           see ourTensorDecomp.m - just passing these inputs along since 
%           need to calculate decomposition in order to compare values of
%           tau
%
% lenSqn
%           scalar: length of sequence of tau values to try at each level of
%           recursion
%
% slopeThreshold
%           scalar: threshold when choosing tau. If the objective function
%           is not flat enough in the neighborhood of the current best 
%           value of tau, "zoom in" on the neighborhood of tau to further
%           refine it
%
% diffThreshold
%           scalar: threshold when choosing tau. Only keep zooming in on
%           neighbors of tau if spacing between options is at least
%           diffThreshold
%
% OUTPUT:
%
% tau
%           scalar: regularization parameter tau that is chosen
%

    tauopts = linspace(oldtau, hightau, lenSqn);

    %--------------------------------------------------------------------%
    tauopts2 = RecurseZoomTau(tauopts, Y, R, D, init, npq, decompfn, nD, oldtau, lenSqn, slopeThreshold, diffThreshold, 1);
    
    % ------------------------------------------------------------------%
    tau = PickTauFromList(tauopts2, Y, R, D, init, npq, decompfn, nD, oldtau);

end

