clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\MATLAB\evaluate\activite_1526.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/10/19 12:45:40

%% Initialize variables.
filename = 'C:\Users\dunch\Documents\MATLAB\evaluate\activite_1516.csv';
delimiter = ',';

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

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
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% convert unix timestamps to Matlab datetimes in local time zone
dt = datetime(stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';
 
%% Get data for a few days to play with
startdate = datenum([2017 9 29 12 0 0]);
enddate = datenum([2017 10 3 12 0 0]);
i = find(datenum(dt) > startdate & datenum(dt) < enddate);
testdates = dt(i);
testsleep = sleepState(i);
[testdates, i] = sort(testdates);
testsleep = testsleep(i);
figure
hold on
plot(testdates, testsleep)
plot(testdates, testsleep, '.')
ylim([-1 4])

% define noon for each date we have data
noon = datevec(testdates);
noon(:, 4) = 12;
noon(:, 5) = 0;
noon(:, 6) = 0;
noon = unique(datenum(noon));
noon(isnan(noon)) = [];
plot(noon, zeros(size(noon)), 'mo')

sleeptimes = [];
waketimes = [];
for n = 2 : length(testsleep)
    if testsleep(n) > 0 && testsleep(n-1) == 0
        plot(testdates(n), testsleep(n), 'ko')
        sleeptimes = [sleeptimes testdates(n)];
    end
end

for n = 2 : length(testsleep)
    if testsleep(n) == 0 && testsleep(n-1) > 0
        plot(testdates(n-1), testsleep(n-1), 'go')
        waketimes = [waketimes testdates(n)];
    end
end





%% Strategy: 
% Is there a main sleep period?
% If there is, define the main sleep period
% Look for secondary sleep periods
% If a secondary sleep period began before 8 am, lump it in with the 
% main sleep period and call the break between the two a night time
% awakening
% Next classify sleep periods that begin after 8 am naps.

for n = 1 : length(noon)-1
    % find all bedtimes on this day
    thisdaysleep = sleeptimes(find(datenum(sleeptimes) > noon(n) & datenum(sleeptimes) < noon(n+1)));
    thisdaywake = waketimes(find(datenum(waketimes) > noon(n) & datenum(waketimes) < noon(n+1)));
    length(thisdaysleep)
    length(thisdaywake)
    disp('next day     ')
end

