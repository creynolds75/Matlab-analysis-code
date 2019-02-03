[dt, durations, sleepState, steps, subjectID] = loadActiviteData;

% replace sleep state with ones
sleepState(find(sleepState>0)) = 1;

% sort the data
[dt,i] = sort(dt);
durations = durations(i);
sleepState = sleepState(i);
datenums = datenum(dt);

figure
plot(dt, sleepState)

% Find moments falling asleep
lastEvent = -1;
startSleep = [];
for n = 1 : length(sleepState)-1
    if sleepState(n) == 0 & sleepState(n+1) == 1
        if lastEvent == 1
            startSleep = [startSleep dt(n+1)];
        end
        lastEvent = 0;
    elseif sleepState(n) == 1 & sleepState(n+1) == 0
        lastEvent = 1;
    end
end

hold on

% Get rid of naps - falling asleep between 9 am and 7 pm
% First find the hours associated with each sleep period timestamp
dv = datevec(startSleep);
hrs = dv(:, 4);
% Next find the sleep periods that start between 9 am and 7 pm
i = find(hrs >= 9 & hrs <= 7+12);
% Remove these from the main sleep list
length(startSleep)
startSleep(i) = [];
length(startSleep)

% Get rid of naps - falling asleep between 9 am and 7 pm
% First find the hours associated with each sleep period timestamp
dv = datevec(startSleep);
hrs = dv(:, 4);
% Next find the sleep periods that start between 9 am and 7 pm
i = find(hrs >= 2 & hrs <= 5);
% Remove these from the main sleep list
length(startSleep)
startSleep(i) = [];
length(startSleep)

% check for last startSleep - refractory period of at least 12 hours
del = [];
for n = 2 : length(startSleep)
    if datenum(startSleep(n)) - datenum(startSleep(n-1)) < 0.5;
        del = [del n];
    end    
end
startSleep(del) = [];


dtsteps = dt;
i = find(steps == 0);
dtsteps(i) = [];

for n = 1 : length(startSleep)
    i = find(dtsteps < startSleep(n));
    timediff = startSleep(n) - dtsteps(i);
    latency(n) = min(timediff);
    latencyTimeStamp(n) = startSleep(n) - latency(n);
end

% % output the data as an Excel file
subjectID = 1516;
headers = {'Subject ID', 'Latency Start', 'Latency Duration (min)'};
filename = ['SleepLatency_1516_test4.xlsx'];
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(latency)
    n/length(latency)
    row = {subjectID, datestr(latencyTimeStamp(n)), minutes(latency(n))};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end
