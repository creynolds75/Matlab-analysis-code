% Input variables
HomeId = 1402;
startdate = datenum([2017 10 1 0 0 0]);
enddate = datenum([2018 5 30 0 0 0]);

import Orcatech.Flags.Areas
import Orcatech.Algorithms.Sleep

% Get the flags for the bathroom 
%bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS);
livingids = Areas.getIds(Sleep.AREA_FLAGS_LIVING_ROOMS);

% Get sensor firings for this home ID between the given dates
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(HomeId, startdate, enddate);

% Find all the bathroom firings where areaid is one of the bathroom ids and
% the event type is 32
% First get all the 32 firings
event32 = find(event==32);
stamp32 = stamp(event32);
areaid_nyce32 = areaid_nyce(event32);
% Next, get the time stamps of the bathroom firings
livingFiringIndices = find(ismember(areaid_nyce32, livingids) == 1);
livingTimeStamps = stamp32(livingFiringIndices);
% Now get the time stamps for the rest of the house 
nonlivingFiringIndices = find(ismember(areaid_nyce32, livingids) == 0);
nonlivingTimeStamps = stamp32(nonlivingFiringIndices);

% find the gaps between the bathroom firings
gaps = diff(livingTimeStamps);
% convert gaps to minutes from days
gaps = gaps * 24*60;
% find gaps greater than 10 minutes
gapsGreaterThan10 = find(gaps > 10);

% find the indices of bathroom firings that represent the start and end of
% a visit to the bathroom
startVisit = gapsGreaterThan10 + 1;
% add the first firing to this list
startVisit = [1 startVisit'];
endVisit = gapsGreaterThan10;
% add the last firing to this list
endVisit = [endVisit' length(livingTimeStamps)];

uniqueDays = unique(floor(livingTimeStamps(startVisit)));
timeTogetherInLiving = zeros(size(uniqueDays));
dates = zeros(size(uniqueDays));
for n = 1 : length(startVisit)
    s = livingTimeStamps(startVisit(n));
    e = livingTimeStamps(endVisit(n));
    d = day(s);
    nonliving = find(nonlivingTimeStamps > s & nonlivingTimeStamps < e);
    if length(nonliving) == 0
        % find the date this belongs to
        date = floor(s);
        i = find(uniqueDays == date);
        timeTogetherInLiving(i) = timeTogetherInLiving(i) + (e-s)*24*60;
         dates(i) = date;
    end
end

dv = datevec(dates);
daymonth = dv(:,1) + dv(:,2)/12;
uniquemonths = unique(daymonth);
for n = 1 : length(uniquemonths)
    i = find(daymonth == uniquemonths(n));
    livingmonthsum(n) = sum(timeTogetherInLiving(i));
    y(n) = floor(uniquemonths(n));
    m(n) = ceil((uniquemonths(n) - y(n)) *12);
    date(n) = datenum([y(n) m(n) 1 0 0 0]);
end

for n = 1 : length(date)
    labels{n} = datestr(date(n), 12);
end