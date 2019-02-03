
import Orcatech.Algorithms.Sleep
import Orcatech.Flags.Areas
% Sleep estimation algorithm for sample data set
% 1. Subject is sleeping in the bedroom
% 2. Subject will sleep between 6 pm and 10 am
% 3. If a gap (length to be determined - maybe ten minutes) is found between 32 events,
% check if the front door opens or firings are found anywhere
% else in the house
% If a firing is found elsewhere they are awake
homeid = 1115;
sixpm = datenum([2017 5 11 17 0 0]);
tenam = datenum([2017 5 12 12 0 0]);
startdate = datenum([2017 5 1 17 0 0]);
enddate = datenum([2017 5 13 12 0 0]);
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);
%convert time zone
%stamp = stamp - 7/24;
    
% * Get Area Ids: Determine the area ids for Sleep.AREA_FLAGS constants
bedids = Areas.getIds(Sleep.AREA_FLAGS_BEDROOMS);
bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS);
walkinids = Areas.getIds(Sleep.AREA_FLAGS_WALK_IN_CLOSETS);
livingids = Areas.getIds(Sleep.AREA_FLAGS_LIVING_ROOMS);
diningids = Areas.getIds(Sleep.AREA_FLAGS_DINING_ROOMS);
leavingid = Areas.getIds(Areas.LEAVING_BEDROOM);
%kitchenids = 27 Areas.getIds(Areas.AREAS_FLAGS_KITCHENS);

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
   % elseif ismember(areaid_nyce(i), kitchenids);
   %     kitchenIndices = [kitchenIndices i];
    elseif ismember(areaid_nyce(i), leavingid)
        frontdoorIndices = [frontdoorIndices i];
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

frontdoorStamps = stamp(frontdoorIndices);
frontdoorEvents = event(frontdoorIndices);

% Find all the 32 firings - 32 = presence detected
presenceDetectedIndices = find(bedroomEvents == 32);

% Find the time stamps for these detections
presenceDetectedTimeStamps = bedroomStamps(presenceDetectedIndices);

% Find time stamps between 5 pm and noon - this will need to be generalized 

nighttimeIndices = find(presenceDetectedTimeStamps > sixpm ...
    & presenceDetectedTimeStamps < tenam);
nighttimeTimeStamps = presenceDetectedTimeStamps(nighttimeIndices);

% Convert this into hours since 6 pm - this will need to be generalized
% MATLAB datenums are given in units of days so multiply by 24 to convert
% to hours
hoursSince6pm = (nighttimeTimeStamps - sixpm)*24;

% Calculate the difference between firings
timeDiffBetweenFirings = diff(hoursSince6pm);

% Find gaps greater than 15 minutes
gaps = find(timeDiffBetweenFirings > 0.25);

startgaps = [];
endgaps = [];


% Are there gaps?
if ~isempty(gaps)
    for i = 1 : length(gaps)
        otherfirings = false;
        startgap = nighttimeTimeStamps(gaps(i));
        endgap = nighttimeTimeStamps(gaps(i)+1);
        disp(['start gap ' datestr(startgap)]);

        % did the front door open during this time?
        % find all the front door time stamps during this time
        frontdoorGapIndices = find(frontdoorStamps > startgap & frontdoorStamps < endgap);
        frontdoorGapEvents = frontdoorEvents(frontdoorGapIndices);
        % Find all instances of the front door opening
        if length(find(frontdoorGapEvents == 31)) > 0
            disp('Door was opened')
            otherfirings = true;
        end
        % did the bathroom sensor fire during this time?
        bathroomGapIndices = find(bathroomStamps > startgap & bathroomStamps < endgap);
        bathroomGapEvents = bathroomEvents(bathroomGapIndices);
        if length(find(bathroomGapEvents == 32)) > 0
            disp('Bathroom firing')
            otherfirings = true;
        end
        
        % did the kitchen sensor fire during this time?
        kitchenGapIndices = find(kitchenStamps > startgap & kitchenStamps < endgap);
        kitchenGapEvents = kitchenEvents(kitchenGapIndices);
        if length(find(kitchenGapEvents == 32)) > 0
            disp('Kitchen firing')
            otherfirings = true;
        end
        
        % did the living room sensor fire during this time?
        livingroomGapIndices = find(livingroomStamps > startgap & livingroomStamps < endgap);
        livingroomGapEvents = livingroomEvents(livingroomGapIndices);
        if length(find(livingroomGapEvents == 32)) > 0
            disp('Living room firing')
            otherfirings = true;
        end
        if otherfirings == false
            startgaps = [startgaps startgap];
            endgaps = [endgaps endgap];
        end
        disp(['end gap ' datestr(endgap)]);
        disp(' ')
    end
end

bedtime = datestr(min(startgaps))
waketime = datestr(max(endgaps))

totaltimeinbed = (max(endgaps) - min(startgaps))*24*60











