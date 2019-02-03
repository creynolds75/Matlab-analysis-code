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
 intactLatency = [];
 intactdate = [];
 namciLatency = [];
 namcidate = [];
 amciLatency = [];
 amcidate = [];
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepLatency ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qLatency] = mysql(query);
    qLatency = qLatency/60;
    del = find(qLatency > 24*60 | qLatency <= 0);
    qLatency(del) = [];
    qdate(del) = [];
    if mci(n) == 0
        intactLatency = [intactLatency qLatency'];
        intactdate = [intactdate qdate'];
    else
        if amci(n) == 1
            amciLatency = [amciLatency qLatency'];
            amcidate = [amcidate qdate'];
        else
            namciLatency = [namciLatency qLatency'];
            namcidate = [namcidate qdate'];
        end
    end
end

mysql('close')

intactdates = min(intactdate):max(intactdate);
dailyAverageIntact = [];

for d = min(intactdate):max(intactdate)
    thisday = find(intactdate == d);
    dailyAverageIntact = [dailyAverageIntact mean(intactLatency(thisday), 'omitnan')];
end
intactdates = intactdates(30:end);
dailyAverageIntact = dailyAverageIntact(30:end);

amcidates = min(amcidate):max(amcidate);
dailyAverageAmci = [];

for d = min(amcidate):max(amcidate)
    thisday = find(amcidate == d);
    dailyAverageAmci = [dailyAverageAmci mean(amciLatency(thisday), 'omitnan')];
end

namcidates = min(namcidate):max(namcidate);
dailyAverageNamci = [];

for d = min(namcidate):max(namcidate)
    thisday = find(namcidate == d);
    dailyAverageNamci = [dailyAverageNamci mean(namciLatency(thisday), 'omitnan')];
end

figure
plot(amcidates, dailyAverageAmci, '.')
datetick('x', 12)
title('Sleep Latency for Amnestic MCI')

figure
plot(namcidates, dailyAverageNamci, '.')
datetick('x', 12)
title('Sleep Latency for Nonamnestic MCI')

figure
plot(intactdates, dailyAverageIntact, '.')
datetick('x', 12)
title('Sleep Latency for Intact MCI')

