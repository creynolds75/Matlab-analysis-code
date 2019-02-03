%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\MATLAB\besmart\pilot.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/01/03 14:10:09

%% Initialize variables.
filename = 'C:\Users\dunch\Documents\MATLAB\besmart\pilot.csv';
delimiter = ',';

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%q%q%q%q%q%[^\n\r]';

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


%% Split data into numeric and cell columns.
rawNumericColumns = {};
rawCellColumns = raw(:, [1,2,3,4,5]);


%% Allocate imported array to column variable names
motor1 = rawCellColumns(:, 1);
motor2 = rawCellColumns(:, 2);
motor3 = rawCellColumns(:, 3);
motor4 = rawCellColumns(:, 4);
motor5 = rawCellColumns(:, 5);


%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawNumericColumns rawCellColumns;


%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\MATLAB\besmart\pilot.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/01/03 14:11:25

%% Initialize variables.
filename = 'C:\Users\dunch\Documents\MATLAB\besmart\pilot.csv';
delimiter = ',';

%% Format string for each line of text:
%   column200: text (%q)
%	column201: text (%q)
%   column202: text (%q)
%	column203: text (%q)
%   column204: text (%q)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%q%q%q%q%q%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
motor6 = dataArray{:, 1};
motor7 = dataArray{:, 2};
motor8 = dataArray{:, 3};
motor9 = dataArray{:, 4};
motor10 = dataArray{:, 5};

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

answer1 = 'the sun rises in the east';
answer2 = 'did you have a good time';
answer3 = 'space is a high priority';
answer4 = 'you are a wonderful example';
answer5 = 'what you see is what you get';
answer6 = 'do not say anything';
answer7 = 'all work and no play';
answer8 = 'hair gel is very greasy';
answer9 = 'the dreamers of dreams';
answer10 = 'all together in one big pile';
for n = 2 : length(motor1)
    if isempty(motor1{n})
        numErrors1(n-1) = NaN;
    else
        numErrors1(n-1) = MinimumStringDistance(answer1, motor1{n});
    end
end

for n = 2 : length(motor2)
    if isempty(motor2{n})
        numErrors2(n-1) = NaN;
    else
        numErrors2(n-1) = MinimumStringDistance(answer2, motor2{n});
    end
end

for n = 2 : length(motor3)
    if isempty(motor3{n})
        numErrors3(n-1) = NaN;
    else
        numErrors3(n-1) = MinimumStringDistance(answer3, motor3{n});
    end
end

for n = 2 : length(motor4)
    if isempty(motor4{n})
        numErrors4(n-1) = NaN;
    else
        numErrors4(n-1) = MinimumStringDistance(answer4, motor4{n});
    end
end

for n = 2 : length(motor5)
    if isempty(motor5{n})
        numErrors5(n-1) = NaN;
    else
        numErrors5(n-1) = MinimumStringDistance(answer5, motor5{n});
    end
end

for n = 2 : length(motor6)
    if isempty(motor6{n})
        numErrors6(n-1) = NaN;
    else
        numErrors6(n-1) = MinimumStringDistance(answer6, motor6{n});
    end
end

for n = 2 : length(motor7)
    if isempty(motor7{n})
        numErrors7(n-1) = NaN;
    else
        numErrors7(n-1) = MinimumStringDistance(answer7, motor7{n});
    end
end

for n = 2 : length(motor8)
    if isempty(motor8{n})
        numErrors8(n-1) = NaN;
    else
        numErrors8(n-1) = MinimumStringDistance(answer8, motor8{n});
    end
end

for n = 2 : length(motor9)
    if isempty(motor9{n})
        numErrors9(n-1) = NaN;
    else
        numErrors9(n-1) = MinimumStringDistance(answer9, motor9{n});
    end
end

for n = 2 : length(motor10)
    if isempty(motor10{n})
        numErrors10(n-1) = NaN;
    else
        numErrors10(n-1) = MinimumStringDistance(answer10, motor10{n});
    end
end


