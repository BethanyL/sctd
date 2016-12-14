function dict = SinCosDict(time, omegaList)

% inputs: 
% time: vector over which the modes should be evaluated, i.e. 0:.1:10
% omegaList: vector of real #s: modes are sin(omega*time), cos(omega*time)

% output:
% dictionary of sine and cosine modes as columns

numOmegas = length(omegaList);

dict = zeros(length(time), 2*numOmegas);

count = 1;
for j = 1:numOmegas
    omega = omegaList(j);
    dict(:,count) = sin(omega*time);
    dict(:,count+1) = cos(omega*time);
    count = count + 2;
end

end

