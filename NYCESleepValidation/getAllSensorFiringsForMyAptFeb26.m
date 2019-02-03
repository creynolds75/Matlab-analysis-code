

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

query = 'SELECT Sensor, Event, Stamp FROM NYCEData.home_1353';
[sensor, event, stamp] = mysql(query);

mysql('close')

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

% find the stamps between 5:00 Feb 26 and noon Feb 27
fiveoclock = datenum([2017 10 10 0 0 0]);
noon = datenum([2017 10 13 23 59 59]);

i = find(bedroomStamps > fiveoclock & bedroomStamps < noon);
bedroomStamps = bedroomStamps(i);
bedroomEvents = bedroomEvents(i);

i = find(livingroomStamps > fiveoclock & livingroomStamps < noon);
livingroomStamps = livingroomStamps(i);
livingroomEvents = livingroomEvents(i);

i = find(bathroomStamps > fiveoclock & bathroomStamps < noon);
bathroomStamps = bathroomStamps(i);
bathroomEvents = bathroomEvents(i);

i = find(kitchenStamps > fiveoclock & kitchenStamps < noon);
kitchenStamps = kitchenStamps(i);
kitchenEvents = kitchenEvents(i);

i = find(frontdoorStamps > fiveoclock & frontdoorStamps < noon);
frontdoorStamps = frontdoorStamps(i);
frontdoorEvents = frontdoorEvents(i);

% find all the 32 events (or 31 for the front door)
i = find(bedroomEvents == 32);
bedroomEvents = bedroomEvents(i);
bedroomStamps = bedroomStamps(i);

i = find(livingroomEvents == 32);
livingroomEvents = livingroomEvents(i);
livingroomStamps = livingroomStamps(i);

i = find(bathroomEvents == 32);
bathroomEvents = bathroomEvents(i);
bathroomStamps = bathroomStamps(i);

i = find(kitchenEvents == 32);
kitchenEvents = kitchenEvents(i);
kitchenStamps = kitchenStamps(i);

i = find(frontdoorEvents == 31);
frontdoorEvents = frontdoorEvents(i);
frontdoorStamps = frontdoorStamps(i);

% We're going to define some codes to represent the different rooms
% 1 = bedroom
% 2 = living room
% 3 = bathroom
% 4 = kitchen
% 5 = front door

% Now we're going to create an array of all the events that happened
% between 5 pm and noon in order
% add time events and codes for each room
allEventStamps = [];
allEventCodes = [];
allEventStamps = [allEventStamps bedroomStamps'];
allEventCodes = [allEventCodes ones(1,length(bedroomStamps))];
allEventStamps = [allEventStamps livingroomStamps'];
allEventCodes = [allEventCodes 2*ones(1,length(livingroomStamps))];
allEventStamps = [allEventStamps bathroomStamps'];
allEventCodes = [allEventCodes 3*ones(1,length(bathroomStamps))];
allEventStamps = [allEventStamps kitchenStamps'];
allEventCodes = [allEventCodes 4*ones(1,length(kitchenStamps))];
allEventStamps = [allEventStamps frontdoorStamps'];
allEventCodes = [allEventCodes 5*ones(1,length(frontdoorStamps))];

% Now sort the event time stamps to be in chronological order
[allEventStamps, i] = sort(allEventStamps);
allEventCodes = allEventCodes(i);

for n = 1 : length(allEventCodes)
    if allEventCodes(n) == 1
        disp([datestr(allEventStamps(n)) ' Bedroom Firing'])
    elseif allEventCodes(n) == 2
        disp([datestr(allEventStamps(n)) ' Livingroom Firing'])
    elseif allEventCodes(n) == 3
        disp([datestr(allEventStamps(n)) ' Bathroom Firing'])
    elseif allEventCodes(n) == 4
        disp([datestr(allEventStamps(n)) ' Kitchen Firing'])
    elseif allEventCodes(n) == 5
        disp([datestr(allEventStamps(n)) ' Front door opened'])
    end
end


figure
hold on
plot(bedroomStamps, 5*ones(size(bedroomStamps)), 'm.');
plot(livingroomStamps, 10*ones(size(livingroomStamps)), 'b.')
plot(bathroomStamps, 15*ones(size(bathroomStamps)), 'g.')
plot(kitchenStamps, 20*ones(size(kitchenStamps)), 'c.')
for n = 1 : length(frontdoorStamps)
    plot([frontdoorStamps(n) frontdoorStamps(n)], [0 25], 'k')
end
ylim([0 25])

