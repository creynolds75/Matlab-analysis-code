% Input variables
HomeId = 1400;
startdate = datenum([2017 8 1 0 0 0]);
enddate = datenum([2017 9 1 0 0 0]);

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

% loop through all bathroom firings
fiveminutes = 5/(24*60);
for n = 1 : length(bathroomTimeStamps)
    % check time difference between 
    
end


