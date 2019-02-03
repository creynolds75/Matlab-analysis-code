uniqueoadc = unique(oadc);

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
numwdata = 0;

MCIgroup = [];
OADC = [];
sex = [];
yrsschool = [];
age = [];
BMI = [];
CIRS = [];
MMSE = [];
GDS = [];
FAQ = [];
daysOfData = [];
for n = 1 : length(uniqueoadc)
    % get sleep data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(uniqueoadc(n)) ' '];
    query4 = 'AND SensorSource = 2 ';
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 4);
    qTST(del) = [];
    qdate(del) = [];
    disp([num2str(uniqueoadc(n)) ' has ' num2str(length(qdate)) ' day of sleep data'])
    if length(qdate) > 0
        MCIgroup = [];
        OADC = [OADC];
        sex = [sex];
        yrsschool = [yrsschool];
age = [];
BMI = [];
CIRS = [];
MMSE = [];
GDS = [];
FAQ = [];
daysOfData = [];
    end
end
mysql('close')