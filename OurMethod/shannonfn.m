function filter = shannonfn( t, width, tau)
% used to apply windows to prototypes
%
% INPUTS:
%
% t 
%       vector, time range that we are defining prototypes on
%
% width
%       scalar, width of window (part that is "on")
%
% tau
%       scalar, center of window: each window is tau +- width/2
%
% OUTPUTS:
%
% filter
%       binary vector same length as t 
% 


filter = ones(length(t),1);
filter(t < tau-width/2) = 0;
filter(t > tau+width/2) = 0;


end


