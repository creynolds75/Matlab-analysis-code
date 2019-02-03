clear all
% Load MCI diagnosis information 
load('mci.mat')

% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

NYCEdate = [];
NYCEwalk = [];
X10date = [];
X10walk = [];


n = 97;
    disp(['OADC index: ' num2str(n)])
% get total time asleep (TST) where SensorSource = 2, for NYCE data
query1 = 'SELECT Date, WalkSpeedMedian ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 2 '];
query = [query1 query2 query3 query4];
[qdate, qwalk] = mysql(query);
disp(['Length NYCE: ' num2str(length(qwalk))])
NYCEwalk = [NYCEwalk qwalk'];
NYCEdate = [NYCEdate qdate'];
    
query1 = 'SELECT Date, WalkSpeedMedian ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 1 '];
query = [query1 query2 query3 query4];
[qdate, qwalk] = mysql(query);
disp(['Length X10: ' num2str(length(qwalk))])
disp(' ' )

X10walk = [X10walk qwalk'];
X10date = [X10date qdate'];

date1 = datenum([2015 1 23 0 0 0]);
date2 = datenum([2015 10 7 0 0 0]);
del = find(NYCEdate < date1 | NYCEdate > date2);
NYCEdate(del) = [];
NYCEwalk(del) = [];
del = find(X10date < date1 | X10date > date2);
X10date(del) = [];
X10walk(del) = [];

figure
hold on
plot(X10date, X10walk, '.-')
plot(NYCEdate, NYCEwalk, '.-')
legend('X10', 'NYCE')
datetick('x', 12)
title(['Median walk time - OADC ' num2str(oadc(n))])
ylabel('cm/sec')