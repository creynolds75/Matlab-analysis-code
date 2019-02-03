% NYCE SENSOR SLEEP ESTIMATION ALGORITHM
% This algorithm takes advantage of the fact that the NYCE sensors will not
% register a presence (event flag 32) if the person in the room is very
% still. It looks for time gaps between 32 events in the bedroom of at
% least 5 minutes. If no other sensors fire in the home during that five
% minutes and the front door does not open, the assumption is that the
% person is still in the bedroom (since the last 32 firing happened in the
% bedroom) and is staying still enough not to trigger the presence sensor
% (is asleep). 

% INPUT INTO ALGORITHM
% The input into the algorithm is the home ID and the date the algorithm
% should calculate sleep for. Sleep is assumed to happen between 6:00 pm on
% the given date and noon the following day.
homeid = 1115;
year = 2017;
month = 5;
day = 11;

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
    %elseif ismember(areaid_nyce(i), leavingid)
     %   frontdoorIndices = [frontdoorIndices i];
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

% frontdoorStamps = stamp(frontdoorIndices);
% frontdoorEvents = event(frontdoorIndices);

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

% Find gaps greater than 5 minutes
gaps = find(timeDiffBetweenFirings > 5/60);

startgaps = [];
endgaps = [];


% Are there gaps?
tst = 0;
if ~isempty(gaps)
    for i = 1 : length(gaps)
        otherfirings = false;
        startgap = nighttimeTimeStamps(gaps(i));
        endgap = nighttimeTimeStamps(gaps(i)+1);
        disp(['start gap ' datestr(startgap)]);

        % did the front door open during this time?
        % find all the front door time stamps during this time
%         frontdoorGapIndices = find(frontdoorStamps > startgap & frontdoorStamps < endgap);
%         frontdoorGapEvents = frontdoorEvents(frontdoorGapIndices);
        % Find all instances of the front door opening
%         if length(find(frontdoorGapEvents == 31)) > 0
%             disp('Door was opened')
%             otherfirings = true;
%         end
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
            tst = tst + (endgap - startgap);
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

tst*24*60;











