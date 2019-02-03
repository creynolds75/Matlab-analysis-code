homeids = unique(HomeID);

dt = datetime(stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';
datenums = datenum(dt);

for n = 1 : length(homeids)
    i = find(HomeID == homeids(n));
    datesthishome = datenums(i);
    homeids(n)
    datestr(min(datesthishome))
    datestr(max(datesthishome))
    disp('   ')
end
