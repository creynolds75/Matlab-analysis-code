import Orcatech.Flags.Areas
import Orcatech.Algorithms.Sleep

startdate = datenum([2018 4 1 0 0 0]);
enddate = datenum([2018 4 2 0 0 0]);
homeid = 1400;
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);
 
% * Get Area Ids: Determine the area ids for Sleep.AREA_FLAGS constants
bedids = Areas.getIds(Sleep.AREA_FLAGS_BEDROOMS);
bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS);
walkinids = Areas.getIds(Sleep.AREA_FLAGS_WALK_IN_CLOSETS);
livingids = Areas.getIds(Sleep.AREA_FLAGS_LIVING_ROOMS);
diningids = Areas.getIds(Sleep.AREA_FLAGS_DINING_ROOMS);
leavingid = 66;
kitchenids = [23 24];

% Now loop through all the areaid_nyce values. This will mark the areaid
% for each event flag. Sort them by which room the sensor fired in.
bedroomIndices = [];
bathroomIndices = [];
kitchenIndices = [];
frontdoorIndices = [];
livingroomIndices = [];
for i = 1 : length(areaid_nyce)
    if ismember(areaid_nyce(i), bedids)
        bedroomIndices = [bedroomIndices i];
    elseif ismember(areaid_nyce(i), livingids)
        livingroomIndices = [livingroomIndices i];
    elseif ismember(areaid_nyce(i), bathids)
        bathroomIndices = [bathroomIndices i];
   elseif ismember(areaid_nyce(i), kitchenids);
       kitchenIndices = [kitchenIndices i];
    elseif ismember(areaid_nyce(i), leavingid)
       frontdoorIndices = [frontdoorIndices i];
    end
end

% Now collect the time stamps and event flags for each room using the
% indices we just collected.
bedroomStamps = stamp(bedroomIndices);
bedroomEvents = event(bedroomIndices);

livingroomStamps = stamp(livingroomIndices);
livingroomEvents = event(livingroomIndices);

bathroomStamps = stamp(bathroomIndices);
bathroomEvents = event(bathroomIndices);

kitchenStamps = stamp(kitchenIndices);
kitchenEvents = event(kitchenIndices);

% get the presence detected (32) time stamps
i = find(bedroomEvents == 32);
bedroomStamps = bedroomStamps(i);
bedroomEvents = bedroomEvents(i);

i = find(livingroomEvents == 32);
livingroomStamps = livingroomStamps(i);
livingroomEvents = livingroomEvents(i);

i = find(bathroomEvents == 32);
bathroomStamps = bathroomStamps(i);
bathroomEvents = bathroomEvents(i);

i = find(kitchenEvents == 32);
kitchenStamps = kitchenStamps(i);
kitchenEvents = kitchenEvents(i);

% loop through the day in five minute blocks
fiveminutes = 5/(24*60); 
for t = startdate : fiveminutes : enddate
    % find all firings in five minute block
    
end


