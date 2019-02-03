% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

% We're only go to use data between Jan 1, 2016 and June 30, 2016
jan2016 = datenum([2016 1 1 0 0 0]);
jun2016 = datenum([2016 6 30 23 59 59]);
jun2015 = datenum([2015 6 30 23 59 59]);

query1 = 'SELECT Date, SleepTST, MotionFiresBed, MotionFiresLiving ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = 11190 '];
query4 = ['AND SensorSource = 2 '];
query = [query1 query2 query3 query4];
[qdate, qTST, bedfires, LRfires] = mysql(query);
mysql('close')

qTST = qTST/3600;
