% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);
sleep22 = []; 
sleep23 = [];
sleep24 = [];
sleep33 = [];
sleep34 = [];
dates = [];
for n = 1 : length(Spatid)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(Spatid(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    dates = [dates qdate'];
   if strcmp(SPCgene1{n}, '2,2')
       sleep22 = [sleep22 qTST'];
   elseif strcmp(SPCgene1{n}, '2,3')
       sleep23 = [sleep23 qTST'];
   elseif strcmp(SPCgene1{n}, '2,4')
       sleep24 = [sleep24 qTST'];
   elseif strcmp(SPCgene1{n}, '3,3')
       sleep33 = [sleep33 qTST'];
   else
       sleep34 = [sleep34 qTST'];
   end
end
mysql('close')
disp(['2,2: ' num2str(mean(sleep22, 'omitnan'))]);
disp(['2,3: ' num2str(mean(sleep23, 'omitnan'))]);
disp(['2,4: ' num2str(mean(sleep24, 'omitnan'))]);
disp(['3,3: ' num2str(mean(sleep33, 'omitnan'))]);
disp(['3,4: ' num2str(mean(sleep34, 'omitnan'))]);

