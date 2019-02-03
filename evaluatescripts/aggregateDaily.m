days = unique(floor(datenum(dt)));

dailysteps = [];
for n = 1 : length(days)
    i = find(floor(datenum(dt)) == days(n));
    dailysteps = [dailysteps sum(steps(i))];
end
