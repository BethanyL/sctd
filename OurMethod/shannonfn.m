function filter = shannonfn( t, width, tau)

filter = ones(length(t),1);
filter(t < tau-width/2) = 0;
filter(t > tau+width/2) = 0;


end


