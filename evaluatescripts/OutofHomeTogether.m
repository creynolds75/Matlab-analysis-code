HomeId = 1400;

% Get sensor data from the Early apartment
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

% get out of home information - this needs to be updated before the
% algorithm will run on this home ID
query = ['SELECT * FROM algorithm_results.out_of_home2 where HomeId = ' num2str(HomeId)];
[HomeId, OutofHomeDate, OutofHomeTime, OutofHomeDuration, DataTypeId] = mysql(query);
mysql('close')