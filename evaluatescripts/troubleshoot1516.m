%% convert unix timestamps to Matlab datetimes in local time zone
dt = datetime(stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';
datenums = datenum(dt);

% Get rid of sleep staging in data
i = find(sleepState > 0);
sleepState(i) = 1;

%% Sort the data to make sure it is in ascending order
[datenums, i ] = sort(datenums);
sleepState = sleepState(i);

start = datenum([2017 11 16 0 0 0]);
stop = datenum([2017 11 20 0 0 0]);

i = find(datenums > start & datenums < stop);
datenums = datenums(i);
sleepState = sleepState(i);

figure
plot(datenums, sleepState);
ticks = linspace(datenums(1), datenums(end), 10);
ax = gca;
ax.XTick = ticks;
datetick('x', 'mm-dd HH:MM', 'keepticks')

ylim([-1 2])