% Input variables
HomeId = 1400;
startdate = datenum([2017 8 1 0 0 0]);
enddate = datenum([2018 6 1 0 0 0]);

import Orcatech.Flags.Areas
import Orcatech.Algorithms.Sleep

% Get the flags for the bathroom 
bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS);

% Get sensor firings for this home ID between the given dates
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(HomeId, startdate, enddate);

% Find all the bathroom firings where areaid is one of the bathroom ids and
% the event type is 32
% First get all the 32 firings
event32 = find(event==32);
stamp32 = stamp(event32);
areaid_nyce32 = areaid_nyce(event32);
% Next, get the time stamps of the bathroom firings
bathroomFiringIndices = find(ismember(areaid_nyce32, bathids) == 1);
bathroomTimeStamps = stamp32(bathroomFiringIndices);
% Now get the time stamps for the rest of the house 
nonbathroomFiringIndices = find(ismember(areaid_nyce32, bathids) == 0);
nonbathroomTimeStamps = stamp32(nonbathroomFiringIndices);

% find the gaps between the bathroom firings
gaps = diff(bathroomTimeStamps);
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
endVisit = [endVisit' length(bathroomTimeStamps)];

% Now check for firings in other rooms

timeTogetherInBathroom = zeros(1000,1);
timeAloneInBathroom = zeros(1000, 1);
dates = [];
for n = 1 : length(startVisit)
    s = bathroomTimeStamps(startVisit(n));
    e = bathroomTimeStamps(endVisit(n));
    d = day(s);
    nonbathroom = find(nonbathroomTimeStamps > s & nonbathroomTimeStamps < e);
    if length(nonbathroom) == 0
        timeTogetherInBathroom(d) = timeTogetherInBathroom(d) + (e-s)*24*60;
            dates = [dates s];
    end

end

timeTogetherInBathroom = timeTogetherInBathroom(1:length(dates));
% figure out how many bathroom visits per day
visitsToBathroom = zeros(31,1);
for n = 1 : length(startVisit)
    s = bathroomTimeStamps(startVisit(n));
    d = day(s);
    visitsToBathroom(d) = visitsToBathroom(d) + 1;
end

% headers = {'Date', 'Total Steps', 'Sleep Latency (min)'};
% filename =  regexprep(filename, '.csv', '_steps.xlsx');
% xlswrite(filename, headers);
% rownum = 2;
% 
% for n = 1 : length(totalsteps)
%     if ~isnan(flooruniquedt(n))
%     row = {datestr(flooruniquedt(n)), totalsteps(n)};
%     xlswrite(filename, row, 1, ['A' num2str(rownum)]);
%     rownum = rownum + 1;
%     end
% end


