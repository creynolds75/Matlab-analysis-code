%%%%%% SENSOR DATA 1
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults
o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);
query = 'SELECT Sensor, Event, convert_tz(stamp, ''''GMT'''', ''''America/Los_Angeles'''') FROM NYCEData.home_1383';
[sensor, event, stamp] = mysql(query);
mysql('close')
% look at data between 
startdate = datenum([2017 6 5 17 0 0]);
enddate = datenum([2017 6 6 12 0 0]);
keep = find(stamp>startdate & stamp < enddate);
sensor = sensor(keep);
event = event(keep);
stamp1 = stamp(keep);

%%%%%%% SENSOR DATA 2
homeid = 1383;
startdate = startdate - 7/24;
enddate = enddate - 7/24;
[ stamp2, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);

