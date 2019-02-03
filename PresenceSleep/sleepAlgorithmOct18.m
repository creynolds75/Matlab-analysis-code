%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\SleepValidation\Home_1145_SleepValData.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2018/10/18 13:18:08

%% Initialize variables.
[file, path] = uigetfile('*.*');
filename = fullfile(path, file);
delimiter = ',';
startRow = 2;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: text (%s)
%   column7: datetimes (%{yyyy-MM-dd HH:mm:ss.SSS}D)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%s%{yyyy-MM-dd HH:mm:ss.SSS}D%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
VarName1 = dataArray{:, 1};
areaid = dataArray{:, 2};
event = dataArray{:, 3};
homeid = dataArray{:, 4};
itemid = dataArray{:, 5};
macaddress = dataArray{:, 6};
stamp = dataArray{:, 7};

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% stamp=datenum(stamp);


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Get start date for data
prompt = {'Enter month when sleep cycle begins:' 'Enter day:', 'Enter year:'};
title = 'Sleep Estimation Date';
answer = inputdlg(prompt, title);
month = str2double(answer(1));
day = str2double(answer(2));
year = str2double(answer(3));

% convert stamps to datetimes and adjust time zone, since inomcing data is
% in UTC
stamp.TimeZone = 'UTC';
stamp.TimeZone = 'America/Los_Angeles';
stamp = datenum(stamp);

% Get rid of heartbeats, which are event == 48
del = find(event == 48);
stamp(del) = [];
areaid(del) = [];
event(del) = [];

% Trim data to be between 7 pm on the start day and 11 am the next morning
startdate = datenum([year month day 19 0 0]);
enddate = datenum([year month day+1 11 0 0]);

i = find(stamp > startdate & stamp < enddate);
stamp = stamp(i);
areaid = areaid(i);

% Sort firings into rooms
import Orcatech.Flags.Areas
import Orcatech.Algorithms.Sleep
% * Get Area Ids: Determine the area ids for Sleep.AREA_FLAGS constants
bedids = Areas.getIds(Sleep.AREA_FLAGS_BEDROOMS);
bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS);
livingids = Areas.getIds(Sleep.AREA_FLAGS_LIVING_ROOMS);
diningids = Areas.getIds(Sleep.AREA_FLAGS_DINING_ROOMS);
frontdoorid = 66;
kitchenids = [23 24];

% Find the indices associated with individual rooms
bedroomIndices = find(ismember(areaid, bedids));
bathroomIndices = find(ismember(areaid, bathids));
livingIndices = find(ismember(areaid, livingids));
diningIndices = find(ismember(areaid, diningids));
frontdoorIndices = find(ismember(areaid, frontdoorid));
kitchenIndices = find(ismember(areaid, kitchenids));

% Associate firings with individual rooms
bedroom = stamp(bedroomIndices);
bathroom = stamp(bathroomIndices);
livingroom = stamp(livingIndices);
diningroom = stamp(diningIndices);
frontdoor = stamp(frontdoorIndices);
kitchen = stamp(kitchenIndices);

% find time differences between bedroom firings
timeDiffBetweenFirings = diff(bedroom);

figure
hold on
plot(bedroom, ones(size(bedroom)), 'k.')
plot(bathroom, 2*ones(size(bathroom)), 'b.')
plot(livingroom, 3*ones(size(livingroom)), 'm.')
plot(diningroom, 4*ones(size(diningroom)), 'g.')

% find all time differences greater than 10 minutes
tenminutes = 10 / (60*24); % ten min in units of days
gaps = find(timeDiffBetweenFirings > tenminutes);
sedentarystart = [];
sedentaryend = [];
for i = 1: length(gaps)
   startgap = bedroom(gaps(i));
   plot(startgap, 1, 'go')
   endgap = bedroom(gaps(i) + 1);
   plot(endgap, 1, 'rx')
   ylim([0 4])
   livingroomfirings = find(livingroom>startgap & livingroom<endgap);
   diningroomfirings = find(diningroom>startgap & diningroom<endgap);
   kitchenfirings = find(kitchen>startgap & kitchen<endgap);
  % bathroomfirings = find(bathroom>startgap & bathroom<endgap);
   frontdoorfirings = find(frontdoor>startgap & frontdoor<endgap);
   otherfirings = length(livingroomfirings)+length(diningroomfirings)+...
       length(kitchenfirings)+length(frontdoorfirings);
   if otherfirings == 0 
       sedentarystart = [sedentarystart startgap];
   else
       sedentaryend = [sedentaryend startgap];
       if hour(startgap) > 1 & hour(startgap) < 9
           break
       end
   end
end

datetick('x')


disp(['Bed time: ' datestr(sedentarystart(1))])
disp(['Wake time: ' datestr(sedentaryend(end))])