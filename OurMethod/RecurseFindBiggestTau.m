function tauopts2 = RecurseFindBiggestTau(tauopts, Y, R, D, init, npq, lenSqn, decompfn, nD, count)
%
% already tried tauopts array: all too big (lambda was NaN)
% need to return sequence of taus to try, but want to avoid going too small
% know oldtau from last iteration (would prefer to beat)
% know our standard for a low tau (would prefer to beat) 
%
% called by FindBiggestTau, which is called by RecurseZoomTau: see that function for explanation of inputs
% count keeps track of how many times we've recursed so that we can stop after 50
%

    tauopts2 = linspace(tauopts(1)/2, tauopts(1), lenSqn);
    bic_sqn = CompareTauSqn(tauopts2, Y, R, D, init, npq, decompfn, nD);
    if bic_sqn(1) < Inf
        % biggest tau that gives finite
        ind = find(bic_sqn < Inf, 1, 'last');
        beg = tauopts2(ind);
        tauopts2 = linspace(beg, tauopts(1), lenSqn);
    else
        if count < 50
            fprintf('all taus too big, recurse to go smaller')
            tauopts2 = RecurseFindBiggestTau(tauopts2, Y, R, D, init, npq, lenSqn, decompfn, nD, count+1);
        else
            tauopts2 = 0;
        end
    end


end

