function tauopts2 = FindBiggestTau(tauopts, Y, R, D, init, npq, lenSqn, decompfn, nD)

% already tried tauopts array: all too big (lambda was NaN)
% need to return sequence of taus to try, but want to avoid going too small
% know oldtau from last iteration (would prefer to beat)
% know our standard for a low tau (would prefer to beat) 

tauopts2 = RecurseFindBiggestTau(tauopts, Y, R, D, init, npq, lenSqn, decompfn, nD, 1);
    
end

