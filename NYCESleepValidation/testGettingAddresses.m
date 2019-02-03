storedprocedure = 'call algorithm_results.getHomeHistory(25, false)';
query = 'SELECT subjectid, address FROM algorithm_results.homehistory';

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

mysql(storedprocedure);
[subjectid, address] = mysql(query);

mysql('close')

uniquesubjectindices = [];
for i = 2 : length(subjectid)
    %is the number repeated?
    if subjectid(i) ~= subjectid(i-1)
        uniquesubjectindices = [uniquesubjectindices i-1];
    end
end
uniquesubjectindices = [uniquesubjectindices length(subjectid)];

subjectid = subjectid(uniquesubjectindices);
address = address(uniquesubjectindices);