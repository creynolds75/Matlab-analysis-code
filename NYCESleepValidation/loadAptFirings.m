import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

query = 'SELECT Sensor, Event, Stamp FROM NYCEData.home_1353';
[sensor, event, stamp] = mysql(query);

mysql('close')

save('myaptallfirings.mat', 'sensor', 'event', 'stamp')