% First convert timestamps to MATLAB
%% convert unix timestamps to Matlab datetimes in local time zone
dt = datetime(stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';
datenums = datenum(dt);

days = unique(day(datenums));
dailyIS = [];
dailyIV = [];
for n = 1 : length(days)
    i = find(day(datenums) == days(n));
    daydatenums = datenums(i);
    % First calculate the hourly means
    hours = hour(daydatenums);
    hourlisting = unique(hours);

    hourlyMeans = [];
    for n = 1 : length(hourlisting)
        i = find(floor(hours) == hourlisting(n));
        hourlyMean = mean(steps(i), 'omitNaN');
        if ~isnan(hourlyMean)
        hourlyMeans = [hourlyMeans hourlyMean];
        end
    end

    n = length(hourlyMeans);
    p = 24;
    meanofalldata = mean(steps, 'omitNaN');

    ISnum = n*sum((hourlyMeans - meanofalldata).^2);
    i = find(~isnan(steps));
    filteredActivity = steps(i);
    ISdenom = p*sum((filteredActivity - meanofalldata).^2);

    IS = ISnum / ISdenom;
    dailsyIS = [dailyIS IS];
    %%%%
    sumn = 0;
    for n = 2 : length(filteredActivity)
        sumn = sumn + (filteredActivity(n) - filteredActivity(n-1))^2;
    end

    IVnum = n*sumn;

    sumn = 0;
    for n = 1 : length(filteredActivity)
        sumn = sumn + (filteredActivity(n) - meanofalldata)^2;
    end

    IVdenom = (n-1) * sumn;

    IV = IVnum/IVdenom;
    dailyIV = [dailyIV IV];
end