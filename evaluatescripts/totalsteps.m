% This script assumes the Activite CSV file has already been loaded

%% convert unix timestamps to Matlab datetimes in local time zone
dt = datetime(stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';

% MATLAB datenums are in days - to create a list of the days represented in
% the dataset, use floor to get rid of the fractional part of each datenum,
% leaving only days. Use unique to create a list of the days represented in
% the data set
flooruniquedt = unique(floor(datenum(dt)));
floordt = floor(datenum(dt));

totalsteps = zeros(size(flooruniquedt));

% for each unique date, sun the number of steps on that date
for n = 1 : length(flooruniquedt)
    i = find(floordt == flooruniquedt(n));
    totalsteps(n) = sum(steps(i));
end




