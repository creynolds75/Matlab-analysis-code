% Import the Nokia CSV file

dt = datetime( stampunix, 'ConvertFrom', 'posixtime' );

flooruniquedt = unique(floor(datenum(dt)));
floordt = floor(datenum(dt));

totalsleeptime = zeros(size(flooruniquedt));

for n = 1 : length(flooruniquedt)
    i = find(floordt == flooruniquedt(n));
    sleepvals = sleep(i);
    durationvals = durations(i);
    for m = 1 : length(sleepvals)
        if sleepvals(m) > 0
            totalsleeptime(n) = totalsleeptime(n) + durationvals(m);
        end
    end
end




