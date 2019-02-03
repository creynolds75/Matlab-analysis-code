% import N110 TO CHRISTY

% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);
sleep4minus = [];
sleep4plus = [];
selfreport4minus = [];
selfreport4plus = [];
ages = [];
numDayseplus = [];
numDayseminus = [];
for n = 1 : length(OADC)
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
    % select only one year of data
    start = min(qdate);
    stop = start + 365;
    i = find(qdate > start & qdate < stop);
    qTST = qTST(i);
     meanTST = mean(qTST);
     stdTST = std(qTST);
     numpts = length(qTST);
     if meanTST >= 4
        if vstCDR(n) == 0  
            if ~isempty(strfind(SPCgene1{n}, '4'))
                sleep4plus = [sleep4plus meanTST];
                numDayseplus = [numDayseplus length(qTST)];
            else
                sleep4minus = [sleep4minus meanTST];
                numDayseminus = [numDayseminus length(qTST)];
            end
        end
     end
end
mysql('close')

meanSleep4Plus = mean(sleep4plus);
stdSleep4Plus = std(sleep4plus);
meanSleep4minus = mean(sleep4minus, 'omitNaN');
stdSleep4minus = std(sleep4minus, 'omitNaN');

% output results
disp(['Mean sleep 4 plus: ' num2str(meanSleep4Plus)])
disp(['Mean sleep 4 minus: ' num2str(meanSleep4minus)])
