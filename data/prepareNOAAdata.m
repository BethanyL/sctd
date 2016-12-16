% prepare NOAA data
% We use the NOAA_OI_SST_V2 dataset from https://www.esrl.noaa.gov/psd/
% want 1990 to 2010 
% file contains weekly means from 1989/12/31 to 2016/04/03 .

filename = 'sst.wkmean.1990-present.nc';

% var{1}: lat, 180x1, 89.5, 88.5, ..., -89.5 (diff always -1)
% var{2}: lon, 360x1, 0.5, 1.5, ..., 359.5 (diff always 1)
% var{3}: sst, 360x180x1371, ranging -1.8 to 35.63, av 12.411, presumably C
% var{4}: time, 1371x1, 69395, 69502, ..., 78985 (diff always 7), days since January 1, 1800
% var{5}: time_bnds, 2x1371, 69395, 69402, ... 78985
%                            69402, 69409, ... 78992
finfo = ncinfo(filename);
var = cell(5,1);
for j = 1:5
    var{j} = ncread(filename,finfo.Variables(j).Name);
end


% want last day in file to be 12/26/2010, which is 1925 days earlier. 
% so end at day 78985 - 1925 = 77060 (remvoing 275 weeks) 
% end at index 1096 instead of 1371 
end2010 = 1096; 
dataThrough2010 = var{3}(:,:,1:end2010);
tempShifted = dataThrough2010 - min(dataThrough2010(:)); % now min is 0
tempScaled = tempShifted / max(tempShifted(:)); % now range 0 - 1
data = tempScaled;

save('preppedNOAAdata.mat','data');

%%
% to get ocean only:
% var{1}: lat 89.5 -> -89.5 changed to 66.5 -> -45.5
lat1 = find(var{1} == 66.5);
lat2 = find(var{1} == -45.5);
% var{2}: lon 0.5 -> 359.5 changed to 134.5 -> (359.5-70) = 289.5
lon1 = find(var{2} == 134.5);
lon2 = find(var{2} == 289.5);
ocean = data(lon1:lon2, lat1:lat2, :); 
save('preppedNOAAdata_ocean.mat','ocean');

% let's look at 1995 - 2000
% file contains weekly means from 1989/12/31 to 2016/04/03 .
% start 5 years in (+260 weeks) and end 10 years earlier than 2010 (-520
% weeks)
start1995 = 262; % January 1, 1995
end2000 = end2010 - 521; % 12/31/2000 is 73413
ocean95to00 = ocean(:,:,start1995:end2000);
save('preppedNOAAdata_ocean95to00.mat','ocean95to00');