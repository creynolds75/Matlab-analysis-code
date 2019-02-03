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
 intactWASO = [];
 intactdate = [];
 namciWASO = [];
 namcidate = [];
 amciWASO = [];
 amcidate = [];
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepWASO ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qWASO] = mysql(query);
    qWASO = qWASO/60;
    del = find(qWASO > 24*60 | qWASO <= 0);
    qWASO(del) = [];
    qdate(del) = [];
    if mci(n) == 0
        intactWASO = [intactWASO qWASO'];
        intactdate = [intactdate qdate'];
    else
        if amci(n) == 1
            amciWASO = [amciWASO qWASO'];
            amcidate = [amcidate qdate'];
        else
            namciWASO = [namciWASO qWASO'];
            namcidate = [namcidate qdate'];
        end
    end
end

mysql('close')

intactdates = min(intactdate):max(intactdate);
dailyAverageIntact = [];

for d = min(intactdate):max(intactdate)
    thisday = find(intactdate == d);
    dailyAverageIntact = [dailyAverageIntact mean(intactWASO(thisday), 'omitnan')];
end
intactdates = intactdates(30:end);
dailyAverageIntact = dailyAverageIntact(30:end);

amcidates = min(amcidate):max(amcidate);
dailyAverageAmci = [];

for d = min(amcidate):max(amcidate)
    thisday = find(amcidate == d);
    dailyAverageAmci = [dailyAverageAmci mean(amciWASO(thisday), 'omitnan')];
end

namcidates = min(namcidate):max(namcidate);
dailyAverageNamci = [];

for d = min(namcidate):max(namcidate)
    thisday = find(namcidate == d);
    dailyAverageNamci = [dailyAverageNamci mean(namciWASO(thisday), 'omitnan')];
end

[~, septIndices, ~] = intersect(intactdates, sept);
[~, decIndices, ~] = intersect(intactdates, dec);
[~, marchIndices, ~] = intersect(intactdates, march);
[~, julyIndices, ~] = intersect(intactdates, july);

septAverage = mean(dailyAverageIntact(septIndices))
decAverage = mean(dailyAverageIntact(decIndices))
marchAverage = mean(dailyAverageIntact(marchIndices))
julyAverage = mean(dailyAverageIntact(julyIndices))