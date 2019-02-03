import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

query = 'select idx, OADC, FName, LName from subjects_new.subjects where OADC > 0';
[idx, OADC, FName, LName] = mysql(query);


xlsFilename = 'OADCsWithGoodSleepDataMay17.xlsx';
r = 1; sheet = 1;
for o = 1 : length(OADC)
    query1 = 'SELECT Date, SleepTST FROM algorithm_results.summary ';
    query2 = ['WHERE OADC = ' num2str(OADC(o)) ' AND '];
    query3 = 'Date BETWEEN ''2017-01-01'' AND ''2017-01-31'' ';
    query = [query1 query2 query3];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    
    query1 = 'SELECT Address, City FROM subjects_new.locations ';
    query2 = ['WHERE idx = ' num2str(idx(o))];
    query = [query1 query2];
    [address, city] = mysql(query);
    
    query1 = 'SELECT phone FROM subjects_new.subject_phones ';
    query2 = ['WHERE idx = ' num2str(idx(o))];
    query = [query1 query2];
    phone = mysql(query);
    
    if length(qTST) == 31 & ~isnan(qTST) & mean(qTST) > 4
        disp([num2str(OADC(o)) ' has an average of ' num2str(mean(qTST))])
        row = {OADC(o), FName{o}, LName{o}, address, city, phone, mean(qTST)};
        cell = ['A' num2str(r)];
        xlswrite(xlsFilename, row, sheet, cell);
        r = r + 1;
    end
end


mysql('close')
