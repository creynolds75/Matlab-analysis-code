% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Date, SleepTST ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = 11034 '];
query4 = 'AND SensorSource = 2 ';
query = [query1 query2 query3 query4];
[qdate, qTST] = mysql(query);

mysql('close')

%convert TST to hours
qTST = qTST/3600;

del = find(qTST == 0);
qTST(del) = [];
qdate(del) = [];

medianWeeklyValue = [];
week = [];
for d = qdate(1) : 7 : qdate(end-7)
    weekTSTIndices = find(qdate > d & qdate < d + 7);
    weeklyValues = qTST(weekTSTIndices);
    medianWeeklyValue = [medianWeeklyValue std(weeklyValues)];
    week = [week d];
end

figure
plot(week, medianWeeklyValue, '.-')
title('Weekly Variance Total Time Asleep')
ylabel('Hours')
datetick('x', 12)
