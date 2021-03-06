[dt, durations, sleepState, steps, subjectID] = loadActiviteData;

% get a day's worth of data
startdate = datenum([2018 1 1 0 0 0]);
enddate = datenum([2018 1 30 59 59 59]);

i = find(datenum(dt)>startdate & datenum(dt)<enddate);
dt = dt(i);
durations = durations(i);
sleepState = sleepState(i);
steps = steps(i);

figure
hold on

for n = 1 : length(sleepState)
    datestr(dt(n))
    if sleepState(n) > 0
        r = day(dt(n));
        step = -2*pi*(durations(n)/(60*60*24))
        hr = hour(dt(n));
        min = minute(dt(n));
        theta = -(2*pi * (hr + min/60)/24)+pi/2;
        thetas = linspace(theta, theta+step, 100);
        plot(r*cos(thetas), r*sin(thetas), 'k', 'LineWidth', 4)
    end
end

for n = 1 : length(steps)
    if steps(n) > 0
        r = day(dt(n));
         step = -2*pi*(durations(n)/(60*60*24));
        hr = hour(dt(n));
        min = minute(dt(n));
        theta = -(2*pi * (hr + min/60)/24) + pi/2;
        plot(linspace(r*cos(theta), r*cos(theta+step), 5), linspace(r*sin(theta), r*sin(theta+step),5), 'r', 'LineWidth', 4)
    end
end
axis square
