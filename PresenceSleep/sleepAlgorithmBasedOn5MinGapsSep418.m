
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
homeid = 1145;
year = 2018;
month = 6;
day = 16;
% 
% stamp.TimeZone = 'UTC';
% stamp.TimeZone = 'America/Los_Angeles';

% Collect all the presence sensor data for the given home ID and given date
import Orcatech.Algorithms.Sleep
import Orcatech.Flags.Areas
sixpm = datenum([year month day 18 0 0]);
noon = datenum([year month day+1 12 0 0]);
% get a few days worth of data to make sure we are including the sleep
% start and end time - better to have too much data than too little
startdate = datenum([year month day 17 0 0]);
enddate = datenum([year month day+2 12 0 0]);
%[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);

stamp = datenum(stamp);

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

frontdoorStamps = stamp(frontdoorIndices);
frontdoorEvents = event(frontdoorIndices);

figure
hold on
plot(bedroomStamps, ones(size(bedroomEvents)), 'r.')
plot(livingroomStamps, 1.1*ones(size(livingroomEvents)), 'g.')
plot(bathroomStamps, 1.2*ones(size(bathroomEvents)), 'b.')
plot(kitchenStamps, 1.3*ones(size(kitchenEvents)), 'k.')
plot(frontdoorStamps, 1.4*ones(size(frontdoorEvents)), 'm.')
datetick('x')

% Find all the 50 firings - 50 = presence detected
presenceDetectedIndices = find(bedroomEvents == 50);

% Find the time stamps for these detections
presenceDetectedTimeStamps = bedroomStamps(presenceDetectedIndices);

figure
hold on
plot(bedroomStamps, ones(size(bedroomEvents)), 'r.')
plot(presenceDetectedTimeStamps, ones(size(presenceDetectedIndices)), 'ro')
plot(livingroomStamps, 1.1*ones(size(livingroomEvents)), 'g.')
plot(bathroomStamps, 1.2*ones(size(bathroomEvents)), 'b.')
plot(kitchenStamps, 1.3*ones(size(kitchenEvents)), 'k.')
plot(frontdoorStamps, 1.4*ones(size(frontdoorEvents)), 'm.')
datetick('x')

% Find time stamps between 6 pm and noon - this will need to be generalized 
nighttimeIndices = find(presenceDetectedTimeStamps > sixpm ...
    & presenceDetectedTimeStamps < noon);
nighttimeTimeStamps = presenceDetectedTimeStamps(nighttimeIndices);

figure
plot(nighttimeTimeStamps, ones(size(nighttimeTimeStamps)), 'r.')
hold on
plot(sixpm, 1, 'ko')
plot(noon, 1, 'bo')
plot(presenceDetectedTimeStamps, 1.5*ones(size(presenceDetectedTimeStamps)), 'g.')
title('nighttimeTimeStamps')

% Convert this into hours since 6 pm - this gets around the awkwardness
% caused by values right before and after midnight
% MATLAB datenums are given in units of days so multiply by 24 to convert
% to hours
hoursSince6pm = (nighttimeTimeStamps - sixpm)*24;

figure
plot(hoursSince6pm, 'r.')
xlabel('hours since 6:00 pm')

% Calculate the difference between firings
timeDiffBetweenFirings = diff(hoursSince6pm);

figure
plot(timeDiffBetweenFirings, 'r.')
xlabel('Time difference between consecutive firings')

% Find gaps greater than 5 minutes
gaps = find(timeDiffBetweenFirings > 10/60);

figure
plot(gaps, timeDiffBetweenFirings(gaps), 'ro')
hold on
plot(timeDiffBetweenFirings, 'r.')
xlabel('Time difference between consecutive firings')

% Collect the start and end values of each of these gaps. Also calculate
% the total sleep time by adding up each gap representing stillness in the
% bedroom with no other firings elsewhere in the house
startgaps = [];
endgaps = [];
totalsleeptime = 0;
figure
plot(nighttimeTimeStamps, ones(size(nighttimeTimeStamps)), 'k.')
datetick('x')
hold on
if ~isempty(gaps)
    for i = 1 : length(gaps)
        otherfirings = false;
        bathroomfiring = false;
        startgap = nighttimeTimeStamps(gaps(i));
        plot(startgap, 1, 'go')
        endgap = nighttimeTimeStamps(gaps(i)+1);
        plot(endgap, 1, 'ro')
        disp(['start gap ' datestr(startgap)]);

        % did the front door open during this time?
        % find all the front door time stamps during this time
        frontdoorGapIndices = find(frontdoorStamps > startgap & frontdoorStamps < endgap);
        frontdoorGapEvents = frontdoorEvents(frontdoorGapIndices);
        %Find all instances of the front door opening
        if length(find(frontdoorGapEvents == 31)) > 0
            disp('Door was opened')
            otherfirings = true;
        end
        % did the bathroom sensor fire during this time?
        bathroomGapIndices = find(bathroomStamps > startgap & bathroomStamps < endgap);
        bathroomGapEvents = bathroomEvents(bathroomGapIndices);
        if length(find(bathroomGapEvents == 50)) > 0
            disp('Bathroom firing')
            otherfirings = true;
            bathroomfiring = true;
        end
        
        % did the kitchen sensor fire during this time?
        kitchenGapIndices = find(kitchenStamps > startgap & kitchenStamps < endgap);
        kitchenGapEvents = kitchenEvents(kitchenGapIndices);
        if length(find(kitchenGapEvents == 50)) > 0
            disp('Kitchen firing')
            otherfirings = true;
        end
        
        % did the living room sensor fire during this time?
        livingroomGapIndices = find(livingroomStamps > startgap & livingroomStamps < endgap);
        livingroomGapEvents = livingroomEvents(livingroomGapIndices);
        if length(find(livingroomGapEvents == 50)) > 0
            disp('Living room firing')
            otherfirings = true;
        end
        % If we have a gap and no other firings occurred elsewhere in the
        % house, consider that a sleep period. Add the length of the gap to
        % the total sleep time and add the start and end of this gap to our
        % list of gaps
       % if otherfirings == false
            totalsleeptime = totalsleeptime + (endgap - startgap);
            startgaps = [startgaps startgap];
        %elseif otherfirings == true | bathroomfirings == true
            endgaps = [endgaps endgap];
        %end
        disp(['end gap ' datestr(endgap)]);
        disp(' ')
    end
end

% Bed time is the earliest start time of one of our gaps. Waking time is
% the latest of the end times of our gaps.
bedtime = datestr(min(startgaps))
i = find(endgaps > datenum([year month day+1 4 0 0 ]));
waketime = datestr(min(endgaps(i)))
% Convert total sleep time to minutes
totalsleeptime = totalsleeptime*24*60














