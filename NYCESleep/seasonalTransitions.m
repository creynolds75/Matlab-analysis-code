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
 intactTrans = [];
 intactdate = [];
 namciTrans = [];
 namcidate = [];
 amciTrans = [];
 amcidate = [];
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, TransitionsCount ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTrans] = mysql(query);

    del = find(qTrans <= 0);
    qTrans(del) = [];
    qdate(del) = [];
    if mci(n) == 0
        intactTrans = [intactTrans qTrans'];
        intactdate = [intactdate qdate'];
    else
        if amci(n) == 1
            amciTrans = [amciTrans qTrans'];
            amcidate = [amcidate qdate'];
        else
            namciTrans = [namciTrans qTrans'];
            namcidate = [namcidate qdate'];
        end
    end
end

mysql('close')

intactdates = min(intactdate):max(intactdate);
dailyAverageIntact = [];

for d = min(intactdate):max(intactdate)
    thisday = find(intactdate == d);
    dailyAverageIntact = [dailyAverageIntact mean(intactTrans(thisday), 'omitnan')];
end
intactdates = intactdates(30:end);
dailyAverageIntact = dailyAverageIntact(30:end);

amcidates = min(amcidate):max(amcidate);
dailyAverageAmci = [];

for d = min(amcidate):max(amcidate)
    thisday = find(amcidate == d);
    dailyAverageAmci = [dailyAverageAmci mean(amciTrans(thisday), 'omitnan')];
end

namcidates = min(namcidate):max(namcidate);
dailyAverageNamci = [];

for d = min(namcidate):max(namcidate)
    thisday = find(namcidate == d);
    dailyAverageNamci = [dailyAverageNamci mean(namciTrans(thisday), 'omitnan')];
end