%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\MATLAB\actigraphs\withings.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2016/10/26 12:48:45

%% Initialize variables.
filename = 'C:\Users\dunch\Documents\MATLAB\actigraphs\withings.csv';
delimiter = ',';

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
withUnixDate = dataArray{:, 1};
withAct = dataArray{:, 2};


%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

withDate = datenum(datetime(withUnixDate, 'ConvertFrom', 'posixtime'));
withAct(withAct>1000) = 1000;
for n = 1 : length(withDate)
    dv = datevec(withDate(n));
    withhours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    withdays(n) = dv(3); 
end

withtheta = withhours *2*pi/24;

x = withdays.*cos(withtheta);
y = withdays.*sin(withtheta);
figure
hold on
for n = 1 : length(x)
plot(x(n), y(n), 'ro', 'MarkerSize', withAct(n)/100)
end