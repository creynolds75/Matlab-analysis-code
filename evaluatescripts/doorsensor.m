% 1. Find all the times when no one is home using out of home algorithm
% 2. 
startdate = datenum([2017 09 24 0 0 0]);
enddate = datenum([2017 09 25 0 0 0]);
homeid = 1394;
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);

doorsensorid = 56;

% find all the door sensor firings
doorfiringstamps = stamp(find(areaid_nyce == doorsensorid));
doorfiringevents = event(find(areaid_nyce == doorsensorid));
opendoorindices = find(doorfiringevents == 31);
opendoorstamps = doorfiringstamps(opendoorindices);

figure
hold on
for n = 1 : length(opendoorstamps)
    plot([opendoorstamps(n) opendoorstamps(n)], [0 40], 'k') 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
dt1516 = datetime( stampunix1516, 'ConvertFrom', 'posixtime' )-7/24;
nonzerosteps1516 = steps1516(find(steps1516 > 0));
nonzerodt1516 = datenum(dt1516(find(steps1516 > 0)));

i = find(nonzerodt1516 > startdate & nonzerodt1516 < enddate);
nonzerodt1516 = nonzerodt1516(i);
nonzerosteps1516 = nonzerosteps1516(i);
plot(nonzerodt1516, nonzerosteps1516, 'r.', 'MarkerSize', 12)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt1517 = datetime( stampunix1517, 'ConvertFrom', 'posixtime' )-7/24;
nonzerosteps1517 = steps1517(find(steps1517 > 0));
nonzerodt1517 = datenum(dt1517(find(steps1517 > 0)));

i = find(nonzerodt1517 > startdate & nonzerodt1517 < enddate);
nonzerodt1517 = nonzerodt1517(i);
nonzerosteps1517 = nonzerosteps1517(i);
plot(nonzerodt1517, nonzerosteps1517, 'b.', 'MarkerSize', 12)

ylim([0 40])

% Get sensor data from the Early apartment
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

% Get all the sensor firings - includes sensor MAC address, event time, and
% time stamp converted to local time
query = 'SELECT Sensor, Event, convert_tz(Stamp, ''GMT'', ''America/Los_Angeles'') FROM NYCEData.home_1394';
[sensor, event, stamp] = mysql(query);

% get out of home information - this needs to be updated before the
% algorithm will run on this home ID
query = 'SELECT * FROM algorithm_results.out_of_home2 where HomeId = 1394 ';
[HomeId, OutofHomeDate, OutofHomeTime, OutofHomeDuration, DataTypeId] = mysql(query);
mysql('close')

