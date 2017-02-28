backflag = 0; % no background
plotflag = 0; % no plotting
Data = VideoExampleData(backflag, plotflag);

rng(1)
sigma = 3;
NoisyData = WhiteGaussian(Data, sigma);

X = NoisyData;
save('./data/Figure5Data.mat','X');

X = Data;
save('./data/Figure4DataNoiseless.mat','X');