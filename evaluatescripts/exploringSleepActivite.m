[dt, durations, sleepState, steps, subjectID] = loadActiviteData;

% replace sleep state with ones
sleepState(find(sleepState>0)) = 1;

% sort the data
[dt,i] = sort(dt);
durations = durations(i);
sleepState = sleepState(i);
datenums = datenum(dt);

% % look at first week's data

% startdate = datenum([2017 9 1 0 0 0]);
% enddate = datenum([2017 9 8 0 0 0]);
% i = find(datenums >= startdate & datenums <= enddate);
% dt = dt(i);
% durations = durations(i);
% sleepState = sleepState(i);
% steps = steps(i);

figure
plot(dt, sleepState)
ylim([0 2])
hold on

startSleep = [];
endSleep = [];
sleepEvents = [];
% there was a case wheree there were two startSleeps in a row because of a
% gap in the data - we need delete events in cases like this
lastEvent = -1;
for n = 1 : length(sleepState)-1
    if sleepState(n) == 0 & sleepState(n+1) == 1
        if lastEvent == 1
            startSleep = [startSleep dt(n+1)];
        end
        lastEvent = 0;
    elseif sleepState(n) == 1 & sleepState(n+1) == 0
        if lastEvent == 0
            endSleep = [endSleep dt(n)];
        end
        lastEvent = 1;
    end
end

mainSleepStart = startSleep;
mainSleepEnd = endSleep;

% make sure we have pairs - each start has an end
% if the first data point is an end, just delete it
 if mainSleepEnd(1) < mainSleepStart(1)
     mainSleepEnd(1) = [];
 end
 
% if the last data point is a start, delete it
if mainSleepStart(end) > mainSleepEnd(end)
    mainSleepStart(end) = [];
end

% IDENTIFY NAPS
% We will define naps as sleep periods which begin between 9 am and 7 pm

% First find the hours associated with each sleep period timestamp
dv = datevec(mainSleepStart);
hrs = dv(:, 4);
% Next find the sleep periods that start between 9 am and 7 pm
i = find(hrs > 9 & hrs < 7+12);
napSleepStart = mainSleepStart(i);
napSleepEnd = mainSleepEnd(i);
% Remove these from the main sleep list
mainSleepStart(i) = [];
mainSleepEnd(i) = [];

% IDENTIFY WASO

wakeTime = datenum(mainSleepStart(2:end)) - datenum(mainSleepEnd(1:end-1));
% find wake times less than 2 hours 
i = find(wakeTime < 2/24);
wasoSleepStart = mainSleepStart(i+1);
wasoSleepEnd = mainSleepEnd(i);
mainSleepStart(i+1) = [];
mainSleepEnd(i) = [];

% Calculate sleep latency
dtsteps = dt;
i = find(steps == 0);
steps(i) = [];
dtsteps(i) = [];
steps = 0.5*ones(size(steps));

plot(mainSleepStart, ones(size(mainSleepStart)), 'go')
plot(mainSleepEnd, ones(size(mainSleepEnd)), 'ro')
plot(napSleepStart, ones(size(napSleepStart)), 'gx')
plot(napSleepEnd, ones(size(napSleepEnd)), 'rx')
plot(wasoSleepStart, ones(size(wasoSleepStart)), 'mx')
plot(wasoSleepEnd, ones(size(wasoSleepEnd)), 'bx')
plot(dtsteps, steps, 'bo')

% Calculate total sleep time for main sleep periods
TST = (datenum(mainSleepEnd) - datenum(mainSleepStart)) * 24;
% Subtract WASO
% find any WASO periods between sleep start and sleep end periods
for n = 1 : length(mainSleepStart)
    % is there a WASO in this sleep period?
    i = find(wasoSleepStart > mainSleepStart(n) & wasoSleepStart < mainSleepEnd(n));
    if ~isempty(i)
        % there could be multiple WASO periods in one night - sum up their
        % lengths
        WASOlength = sum(datenum(wasoSleepStart(i)) - datenum(wasoSleepEnd(i)))*24;
        % remove this time from the TST
        TST(n) = TST(n) - WASOlength;
    end
    
end

% Calculate nap times
NapTimes = (datenum(napSleepEnd) - datenum(napSleepStart))* 24;

% Calculate WASO
WASOlengths = (datenum(wasoSleepStart) - datenum(wasoSleepEnd))*24;

% output the data as an Excel file
headers = {'Subject ID', 'Period Start', 'Period End', 'Length (Hrs)', 'Period Type'};
filename = ['SleepData_' subjectID '.xlsx'];
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(mainSleepStart)
    row = {subjectID, datestr(mainSleepStart(n)), datestr(mainSleepEnd(n)), TST(n), 'Main' };
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end

for n = 1 : length(napSleepStart)
    row = {subjectID, datestr(napSleepStart(n)), datestr(napSleepEnd(n)), NapTimes(n), 'Nap'};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end

for n = 1 : length(wasoSleepStart)
    row = {subjectID, datestr(wasoSleepEnd(n)), datestr(wasoSleepStart(n)), WASOlengths(n), 'WASO'};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end


