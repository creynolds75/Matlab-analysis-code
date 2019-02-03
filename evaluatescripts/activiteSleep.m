%% Load the Activite data file
%% Initialize variables.
[filename, pathname] = uigetfile;
fullfilename = fullfile(pathname, filename);
delimiter = ',';

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(fullfilename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
stampunix = cell2mat(raw(:, 1));
durations = cell2mat(raw(:, 2));
steps = cell2mat(raw(:, 3));
distancecm = cell2mat(raw(:, 4));
runState0not = cell2mat(raw(:, 5));
running = cell2mat(raw(:, 6));
sleepState = cell2mat(raw(:, 7));


%% Clear temporary variables
clearvars delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% We're going to loop through all the data and look for when sleep starts
% We'll start with the assumption that the person is awake
asleep = false;
sleepTimes = [];
wakeTimes = [];
% Loop through the data and find all time points when the person just fell
% asleep or just woke up
for n = 1 : length(sleepState)
    currentSleepState = sleepState(n);
    % If current sleep state is greater than zero, person is asleep
    if currentSleepState > 0
        % if the person was not asleep in the previous loop, they have
        % fallen asleep
        if asleep == false
            % Add that sleep time to the list of falling asleep times
            sleepTimes = [sleepTimes datenums(n)];
            asleep = true;
        end
    % if the current sleep state equals zero, the person is awake
    else
        % if the person was asleep in the previous loop, they have woken up
        if asleep == true
            % Add that wakening time to the list of wakening times
            wakeTimes = [wakeTimes datenums(n)];
            asleep = false;
        end
    end
end

% We're going to define the main sleep periods. For now we'll include all
% sleep periods as main sleep periods
mainperiodsleep = sleepTimes;
mainperiodwake = wakeTimes;

figure
hold on
plot(datenums, sleepState, '.-')
plot(sleepTimes, zeros(size(sleepTimes)), 'bo')
plot(wakeTimes, zeros(size(wakeTimes)), 'go')
ylim([-0.5 3.5])
 
%% Deal with night awakenings
% if the person falls asleep again within 2 hours of the last time they 
% woke up, that's a night awakening
fragmentSleep = [];
fragmentWake = [];
removeSleep = [];
removeWake = [];
% Loop through all the sleep times and look for any falling asleep time
% that occurs within two hours of the previous awakening time
for n = 2 : length(sleepTimes)
    if datenum(sleepTimes(n)) - datenum(wakeTimes(n-1)) < 2/24
        % Add the sleep and wake time for this fragment to our list of
        % sleep fragments
        fragmentSleep = [fragmentSleep sleepTimes(n)];
        fragmentWake = [fragmentWake wakeTimes(n-1)];
        % Remove the time waking up (start of the fragment) and time
        % falling back asleep (end of the fragment) from the main list of
        % sleep and wake times
        removeSleep = [removeSleep n];
        removeWake = [removeWake n-1];
    end
end
sleepTimes(removeSleep) = [];
wakeTimes(removeWake) = [];
plot(fragmentSleep, zeros(size(fragmentSleep)), 'kx')
plot(fragmentWake, zeros(size(fragmentWake)), 'kx')

%% Now deal with naps 
napSleep = [];
napWake = [];
removeSleep = [];
removeWake = [];
% Loop through all of the times falling asleep
for n = 2 : length(sleepTimes)-1
    % Calculate the time span between falling asleep and the previous
    % wakening up
    spanBefore = datenum(sleepTimes(n)) - datenum(wakeTimes(n-1));
    % Calculate the time between the next time falling asleep and the time
    % waking up
    spanAfter = datenum(sleepTimes(n+1)) - datenum(wakeTimes(n));
    % If there is between 3 and 6 hours before and after a sleep period,
    % this sleep period is isolated from the main sleep period and is a
    % nap.
    if spanBefore > 3/24 & spanAfter < 6/24
        % Add the sleep and awakeing times to the nap list
        napSleep = [napSleep sleepTimes(n+1)];
        napWake = [napWake wakeTimes(n+1)];
        % Remove the nap times from the main sleep period list
        removeSleep = [removeSleep n+1];
        removeWake = [removeWake n+1];
    end
end
sleepTimes(removeSleep) = [];
wakeTimes(removeWake) = [];
% 
plot(napSleep, 0*ones(size(napSleep)), 'rx')
plot(napWake, 0*ones(size(napWake)), 'rx')
% 
for n = 1 : length(sleepTimes)
    plot([sleepTimes(n) sleepTimes(n)], [0 4], 'r')
    plot([wakeTimes(n) wakeTimes(n)], [0 4], 'g')
end
% 


%% Sleep latency
% To find sleep latency, subtract the last active time stamp from the
% falling asleep time point
i = find(sleepState == 0);
activeStamps = datenums(i);
bedTime = [];
for n = 1 : length(sleepTimes)
    i = find(activeStamps < sleepTimes(n));
    beforeBed = sort(activeStamps(i));
    if length(beforeBed) > 0
    bedTime = [bedTime beforeBed(end)];
    end
end
for n = 1 : length(bedTime)
    plot([bedTime(n) bedTime(n)], [0 4], 'k')
end
datetick('x')
if length(sleepTimes) == length(bedTime)
sleepLatency = (datenum(sleepTimes) - datenum(bedTime)) * 24*60;
else 
    sleepLatency = (datenum(sleepTimes(2:end)) - datenum(bedTime)) * 24*60;
end

% create an excel spreadsheet with the following fields:
% date, sleep latency, bed time, wake time, number of night wakenings
% number of naps

headers = {'Bed time', 'Wakening Time', 'Sleep Latency (min)', 'Num of Night Wakenings', 'Num of Naps', 'WASO (hrs)', 'Nap Time (hrs)', 'Total Sleep Time (hrs)'};
filename =  regexprep(filename, '.csv', '_sleep.xlsx');
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(bedTime) - 1
    % find all the night awakenings
    i = find(fragmentWake > bedTime(n) & fragmentWake < wakeTimes(n));
    numOfNightWakenings = length(i);
    if numOfNightWakenings > 0
        WASO = 0;
        for m = 1 : length(i)
            WASO = WASO + (fragmentSleep(i(m)) - fragmentWake(i(m)))*24;
        end
    else
        WASO = 0;
    end
    TST = (wakeTimes(n) - bedTime(n)) * 24 - WASO;
    if length(wakeTimes) > length(bedTime)
        TST = (wakeTimes(n+1) - bedTime(n)) * 24 - WASO;
    end
    i = find(napSleep > wakeTimes(n) & napSleep < bedTime(n+1));
    numOfNaps = length(i);
    
    if numOfNaps > 0
        napTime = 0;
        for m = 1 : length(i)
            napTime = napTime + (napWake(i(m)) - napSleep(i(m)))*24;
        end
    else
        napTime = 0;
    end
    
    row = {datestr(bedTime(n)), datestr(wakeTimes(n)), sleepLatency(n), numOfNightWakenings, numOfNaps, WASO, napTime, TST};
   if TST < 14
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
   end
    
end
