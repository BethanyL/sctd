% load csv files created from saveCrimeTensor.R. Form them into a tensor and save as .mat file.

aa = csvread('hour-by-beat_AggravatedAssault2.csv',1,1);
at = csvread('hour-by-beat_AutoTheft2.csv',1,1);
b = csvread('hour-by-beat_Burglary2.csv',1,1);
r = csvread('hour-by-beat_Robbery2.csv',1,1);
t = csvread('hour-by-beat_Theft2.csv',1,1);

% hour x beat
[nRows, nColms] = size(t);

% type x beat x hour
crimeTBH = zeros(5, nColms, nRows);
crimeTBH(1,:,:) = aa';
crimeTBH(2,:,:) = at';
crimeTBH(3,:,:) = b';
crimeTBH(4,:,:) = r';
crimeTBH(5,:,:) = t';

save('HoustonCrime2.mat', 'crimeTBH');
