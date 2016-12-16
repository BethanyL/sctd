function un = WhiteGaussian(u, sigma)
% add white Gaussian noise to data
%
% INPUTS:
%
% u
%       3-D matrix of data
%
% sigma
%       scalar for "strength" of noise:
%       we add white Gaussian noise with standard deviation sigma 
%       in the frequency domain
%
% OUTPUTS:
%
% un
%       3-D matrix of noisy data
%
%

[r,c,t] = size(u);
ut = fft(u);
utn = ut + sigma*(randn(r,c,t) + 1i*randn(r,c,t));
un = ifft(utn);
un = real(un);

end

