% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);
sleepsubjects = [];
sleepfirstdate = [];
for n = 1 : length(Spatid)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(Spatid(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    if ~isempty(qTST)
        sleepsubjects = [sleepsubjects Spatid(n)];
        sleepfirstdate = [sleepfirstdate min(qdate)];
    end
end
mysql('close')


headers = {'OADC', 'First date of sleep data'};
filename =  'APOEsleepsubjects.xlsx';
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(sleepsubjects)
    row = {sleepsubjects(n), datestr(sleepfirstdate(n))};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end
