import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Date, SleepTST ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = 11150 '];
query4 = '';% 'AND SensorSource = 2 ';
query = [query1 query2 query3 query4];
[qdate, qTST] = mysql(query);
mysql('close')
del = find(qTST == 0);
qdate(del) = [];
qTST(del) = [];
del = find(qTST > 24*3600);
qdate(del) = [];
qTST(del) = [];
% convert TST to hours
qTST = qTST/3600;

figure
hold on
plot(qdate, qTST)

d = datenum([2014 8 8 0 0 0]);
% d = datenum([2015 12 11 0 0 0]);
 plot([d d], [0 20], 'r')
 
 d = datenum([2015 7 1 0 0 0]);
 plot([d d], [0 20], 'r')
% 
% d = datenum([2014 12 12 0 0 0]);
% plot([d d], [0 16], 'g')

datetick('x', 12)


title('OADC 11150')

