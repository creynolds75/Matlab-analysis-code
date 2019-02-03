% stamp.TimeZone = 'UTC';
% stamp.TimeZone = 'America/Los_Angeles';
% stamp = datenum(stamp);
% 
% del = find(event == 48);
% stamp(del) = [];
% areaid(del) = [];
% event(del) = [];

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

figure
hold on
plot(bedroom, ones(size(bedroom)), 'k.', 'MarkerSize', 18)
plot(bathroom, 2*ones(size(bathroom)), 'b.', 'MarkerSize', 18)
plot(livingroom, 3*ones(size(livingroom)), 'm.', 'MarkerSize', 18)
plot(kitchen, 4*ones(size(kitchen)), 'r.', 'MarkerSize', 18)
ylim([0 5])
title('Room Sensor Motion Detections')
 datetick('x', 'mmmm dd')
  set(gca,'YTick', [])
 


