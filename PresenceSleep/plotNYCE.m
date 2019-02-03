% INPUT INTO ALGORITHM
% The input into the algorithm is the home ID and the date the algorithm
% should calculate sleep for. Sleep is assumed to happen between 6:00 pm on
% the given date and noon the following day.
homeid = 1394;
year = 2018;
month = 1;
day = 14;

% Collect all the presence sensor data for the given home ID and given date
import Orcatech.Algorithms.Sleep
import Orcatech.Flags.Areas
startdate = datenum([year month day 18 0 0]);
enddate = datenum([year month day+1 12 0 0]);
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);

    
% * Get Area Ids: Determine the area ids for Sleep.AREA_FLAGS constants
bedids = [4 5 6];
bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS)
walkinids = Areas.getIds(Sleep.AREA_FLAGS_WALK_IN_CLOSETS)
livingids = Areas.getIds(Sleep.AREA_FLAGS_LIVING_ROOMS)
diningids = Areas.getIds(Sleep.AREA_FLAGS_DINING_ROOMS)
kitchenids = Areas.getIds(Areas.AREAS_FLAGS_KITCHENS);

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
    end
end

bedroomStamps = stamp(bedroomIndices);
bedroomEvents = event(bedroomIndices);

livingroomStamps = stamp(livingroomIndices);
livingroomEvents = event(livingroomIndices);

bathroomStamps = stamp(bathroomIndices);
bathroomEvents = event(bathroomIndices);

kitchenStamps = stamp(kitchenIndices);
kitchenEvents = event(kitchenIndices);

i = find(bedroomEvents == 32);
bedroomStamps = bedroomStamps(i);

i = find(livingroomEvents == 32);
livingroomStamps = livingroomStamps(i);

i = find(kitchenEvents == 32);
kitchenStamps = kitchenStamps(i);

i = find(bathroomEvents == 32);
bathroomStamps = bathroomStamps(i);

figure
hold on
plot(bedroomStamps, ones*size(bedroomStamps), 'r.')
plot(livingroomStamps, ones*size(livingroomStamps), 'g.')
plot(kitchenStamps, ones*size(kitchenStamps), 'k.')
plot(bathroomStamps, ones*size(bathroomStamps), 'm.')