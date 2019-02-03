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

query = ['SELECT Sensor, Event, Stamp FROM NYCEData.home_1353 where Sensor = 000D6F0004D3912C'];
[sensor, event, stamp] = mysql(query);

mysql('close')