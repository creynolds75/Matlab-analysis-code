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
livingroom = '000D6F000409133A';
bedroomIndices = [];
livingroomIndices = [];
for i = 1 : length(sensor)
    if strcmp(sensor{i}, bedroom)
        bedroomIndices = [bedroomIndices i];
    elseif strcmp(sensor{i}, livingroom)
        livingroomIndices = [livingroomIndices i];
    end
    disp(i/length(sensor))
end

bedroomStamps = stamp(bedroomIndices);
bedroomEvents = event(bedroomIndices);

livingroomStamps = stamp(livingroomIndices);
livingroomEvents = event(livingroomIndices);

% convert stamps to local time
% GMT is 8 hours ahead of PST, so subtract
% 8 hours from the timestamps
GMTtoPST = 8/24;
bedroomStamps = bedroomStamps - GMTtoPST;
livingroomStamps = livingroomStamps - GMTtoPST;

startdate = datenum([2017 2 26 12 0 0]);
enddate = datenum([2017 2 27 12 0 0 ]);
sampleIndices = find(bedroomStamps > startdate & bedroomStamps < enddate);
sampleStamps = bedroomStamps(sampleIndices);
sampleEvents = bedroomEvents(sampleIndices);

startLR = datenum([2017 2 26 0 0 0]);
endLR = datenum([2017 2 26 23 59 59]);
sampleIndices = find(livingroomStamps > startLR & livingroomStamps < endLR);
sampleLRStamps = livingroomStamps(sampleIndices);
sampleLREvents = livingroomEvents(sampleIndices);




