import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Date, SleepLatency, SleepTST, SleepWASO, SleepAsleep, SleepWake FROM algorithm_results.summary2 ';
query2 = 'WHERE HomeId = 1353';
query = [query1 query2]
[qdate, latency, TST, WASO, asleep, wake] = mysql(query);


mysql('close')

filename = 'sleepMyApt.xlsx';
r = 1; sheet = 1;

for n = 1 : length(qdate)
    row = {datestr(qdate(n)), latency(n), TST(n), WASO(n), asleep(n), wake(n)};
    cell = ['A' num2str(r)];
    xlswrite(filename, row, sheet, cell);
    r = r + 1;
end