function un = WhiteGaussian(u, strength)

% add white gaussian noise to u
[r,c,t] = size(u);
ut = fft(u);
utn = ut + strength*(randn(r,c,t) + 1i*randn(r,c,t));
un = ifft(utn);
un = real(un);

end

