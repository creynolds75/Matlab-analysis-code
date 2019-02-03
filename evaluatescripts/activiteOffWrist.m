% calculate the percentage of day covered by an Activite watch 
[dt, durations, sleepState, steps] = loadActiviteData;

% Sort the data to be ascending
[dt, i] = sort(dt);
durations = durations(i);
sleepState = sleepState(i);
steps = steps(i);

% Convert date-times to datenums
datenums = datenum(dt);

% Convert durations to units of days instead of seconds
dayDurations = durations/(24*60*60);

% adding durations (in day units) to the datenums should result in the next
% datenum if the gap between consecutive datenums is equal to the duration
% plot this to check if true
figure
plot(datenums, '.')
hold on
spans = datenums+dayDurations;
% tack on an extra value to spans to make it plot right
spans = [datenums(1) spans'];
plot(spans, 'ro')

% find where spans does not equal datenums
d = abs(spans(1:end-1) - datenums');
i = find(d>0.01);

plot(i, spans(i), 'kx')

% plot the number of steps per duration
figure
hold on
plot(dt, steps, '.')
plot(dt(i), 10*ones(size(dt(i))), 'ro')
plot(dt(i-1), 15*ones(size(dt(1))), 'go')
for n = 1 : length(dt(i))
    plot([dt(i-1) dt(i)], [15 10], 'k', 'LineWidth', 3)
end
sum(datenums(i) - datenums(i-1))

startSpans = dt(i);
endSpans = dt(i-1);






