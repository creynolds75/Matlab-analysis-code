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
starttime = datenum([2017 6 1 0 0 0]);
endtime = datenum([2017 6 8 23 59 59]);

keep = find(stamp>starttime & stamp < endtime);
sensor = sensor(keep);
event = event(keep);
stamp_orig = stamp_orig(keep);



