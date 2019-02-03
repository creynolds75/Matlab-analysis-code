% calculate the percentage of day covered by an Activite watch 
[dt, durations, sleepState, steps] = loadActiviteData;

% Choose to trim this data to April
start = datenum([2018 4 21 0 0 0]);
stop = datenum([2018 4 27 0 0 0]);
i = find(datenum(dt) > start & datenum(dt) < stop);
dtApril = dt(i);
durationsApril = durations(i);
sleepStateApril = sleepState(i);
stepsApril = steps(i);

% Sort the data to be ascending
[dtApril, i] = sort(dtApril);
durationsApril = durationsApril(i);
sleepStateApril = sleepStateApril(i);
stepsApril = stepsApril(i);

% Convert date-times to datenums
datenumsApril = datenum(dtApril);

% Convert durations to units of days instead of seconds
dayDurationsApril = durationsApril/(24*60*60);

% adding durations (in day units) to the datenums should result in the next
% datenum if the gap between consecutive datenums is equal to the duration
% plot this to check if true
figure
plot(datenumsApril, '.')
hold on
spans = datenumsApril+dayDurationsApril;
% tack on an extra value to spans to make it plot right
spans = [datenumsApril(1) spans'];
plot(spans, 'ro')

% find where spans does not equal datenumsApril
d = abs(spans(1:end-1) - datenumsApril');
i = find(d>0.01);

plot(i, spans(i), 'kx')

% plot the number of steps per duration
figure
hold on
plot(dtApril, stepsApril, '.')
plot(dtApril(i), stepsApril(i), 'ro')
plot(dtApril(i-1), stepsApril(i-1), 'go')

sum(datenumsApril(i) - datenumsApril(i-1))







