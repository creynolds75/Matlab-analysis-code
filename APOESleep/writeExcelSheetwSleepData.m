import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

fileID = fopen('APOEsleepdata.txt', 'w');
dates = [];
for n = 1 : length(OADC)
    n/length(OADC)
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(OADC(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    
    start = min(qdate);
    stop = start + 365;
    i = find(qdate > start & qdate < stop);
    qTST = qTST(i);
    qdate = m2xdate(qdate(i));
    dates = [dates qdate'];
    for m = 1 : length(qTST)
        fprintf(fileID, '%i, %s, %s, %f \n', OADC(n), SPCgene1{n}, qdate(m), qTST(m))
    end
    
end
fclose(fileID)
mysql('close')