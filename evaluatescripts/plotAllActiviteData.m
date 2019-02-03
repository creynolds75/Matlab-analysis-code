[dt, durations, sleepState, steps, subjectID] = loadActiviteData;
[dt, i] = sort(dt);
durations = durations(i);
sleepState = sleepState(i);
steps = steps(i);

figure 
hold on
title(subjectID)


for n = 1 : length(dt)
    if steps(n) > 0
        dt(n)
        hr = hour(dt(n));
        min = minute(dt(n));
        plot([floor(datenum(dt(n))) floor(datenum(dt(n)))],[hr+min/60 hr+min/60+60/3600] , 'r', 'LineWidth', 4)
    end
end

for n = 1 : length(dt)
    if sleepState(n) > 0
        hr = hour(dt(n));
        min = minute(dt(n));
        plot([floor(datenum(dt(n))) floor(datenum(dt(n)))],[hr+min/60 hr+min/60+durations(n)/3600] , 'k', 'LineWidth', 4)
    end
end

 datetick('x')
ylim([0 24])
ylabel('Hour')
