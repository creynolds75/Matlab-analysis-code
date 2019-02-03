


% Sleep estimation algorithm for sample data set
% Sample data is event markers and time stamps from my bedroom
% between Sunday Feb 26 at noon and Monday Feb 27 at noon
% Assumptions:
% 1. Subject is sleeping in the bedroom
% 2. Subject will sleep between 6 pm and 10 am
% 3. If a gap (length to be determined - maybe ten minutes) is found between 32 events,
% check if the front door opens or firings are found anywhere
% else in the house
% If a firing is found elsewhere they are awake

bedroom = '000D6F0004D3912C';
bathroom = '000D6F0004B0EC47';
kitchen = '000D6F0004D38BFD';
frontdoor = '000D6F0000E3EDAD';
livingroom = '000D6F000409133A';

bedroomIndices = [];
bathroomIndices = [];
kitchenIndices = [];
frontdoorIndices = [];
livingroomIndices = [];
for i = 1 : length(sensor)
    if strcmp(sensor{i}, bedroom)
        bedroomIndices = [bedroomIndices i];
    elseif strcmp(sensor{i}, livingroom)
        livingroomIndices = [livingroomIndices i];
    elseif strcmp(sensor{i}, bathroom)
        bathroomIndices = [bathroomIndices i];
    elseif strcmp(sensor{i}, kitchen)
        kitchenIndices = [kitchenIndices i];
    elseif strcmp(sensor{i}, frontdoor)
        frontdoorIndices = [frontdoorIndices i];
    end
    disp(i/length(sensor))
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


% convert stamps to local time
% GMT is 8 hours ahead of PST, so subtract
% 8 hours from the timestamps
GMTtoPST = 8/24;
bedroomStamps = bedroomStamps - GMTtoPST;
livingroomStamps = livingroomStamps - GMTtoPST;
bathroomStamps = bathroomStamps - GMTtoPST;
kitchenStamps = kitchenStamps - GMTtoPST;
frontdoorStamps = frontdoorStamps - GMTtoPST;

% Find all the 32 firings - 32 = presence detected
presenceDetectedIndices = find(bedroomEvents == 32);

% Find the time stamps for these detections
presenceDetectedTimeStamps = bedroomStamps(presenceDetectedIndices);

% Find time stamps between 5 pm and noon - this will need to be generalized 
sixpm = datenum([2017 4 17 17 0 0]);
tenam = datenum([2017 4 18 12 0 0]);
nighttimeIndices = find(presenceDetectedTimeStamps > sixpm ...
    & presenceDetectedTimeStamps < tenam);
nighttimeTimeStamps = presenceDetectedTimeStamps(nighttimeIndices);

% Convert this into hours since 6 pm - this will need to be generalized
% MATLAB datenums are given in units of days so multiply by 24 to convert
% to hours
hoursSince6pm = (nighttimeTimeStamps - sixpm)*24;

% Calculate the difference between firings
timeDiffBetweenFirings = diff(hoursSince6pm);

% Find gaps greater than one hour
gaps = find(timeDiffBetweenFirings > 1);

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

bedtime = min(startgaps);
waketime = max(endgaps);











