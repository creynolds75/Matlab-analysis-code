bedroom = '000D6F0004D3912C';
bathroom = '000D6F0004B0EC47';
kitchen = '000D6F0004D38BFD';
frontdoor = '000D6F0000E3EDAD';
livingroom = '000D6F000409133A';

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

query = 'SELECT Sensor, Event, Stamp FROM NYCEData.home_1353';
[sensor, event, stamp] = mysql(query);

mysql('close')

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


