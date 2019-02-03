% First convert timestamps to MATLAB
%% convert unix timestamps to Matlab datetimes in local time zone
dt = datetime(stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';
datenums = datenum(dt);

days = unique(floor(datenums));
meanSteps = [];
for n = 1 : length(days)
    i = find(floor(datenums) == days(n));
    dailysteps = steps(i);
    meanSteps = [meanSteps mean(steps(i))];
end

