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
intactLat = [];
intactdate = [];
namciLat = [];
namcidate = [];
amciLat = [];
amcidate = [];
 
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepLatency ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qLat] = mysql(query);
    qLat = qLat/60;
    del = find(qLat > 24*60 | qLat <= 0);
    qLat(del) = [];
    qdate(del) = [];
    if mci(n) == 0 
        intactLat = [intactLat qLat'];
        intactdate = [intactdate qdate'];
    else
        if amci(n) == 1
            amciLat = [amciLat qLat'];
            amcidate = [amcidate qdate'];
        else
            namciLat = [namciLat qLat'];
            namcidate = [namcidate qdate'];
        end
    end
end
mysql('close')


weeklyMedianIntactLat = [];
weekIntactStarts = [];
for d = min(intactdate)+21:7:max(intactdate)
    thisweek = find(intactdate >= d & intactdate < d+7);
    weeklyMedianIntactLat = [weeklyMedianIntactLat median(intactLat(thisweek), 'omitnan')];
    weekIntactStarts = [weekIntactStarts d];
end

weeklyMedianAmciLat = [];
weekAmciStarts = [];
for d = min(amcidate)+21:7:max(amcidate)
    thisweek = find(amcidate >= d & amcidate < d+7);
    weeklyMedianAmciLat = [weeklyMedianAmciLat median(amciLat(thisweek), 'omitnan')];
    weekAmciStarts = [weekAmciStarts d];
end

weeklyMedianNamciLat = [];
weekNamciStarts = [];
for d = min(amcidate)+21:7:max(amcidate)
    thisweek = find(namcidate >= d & namcidate < d+7);
    weeklyMedianNamciLat = [weeklyMedianNamciLat median(namciLat(thisweek), 'omitnan')];
    weekNamciStarts = [weekNamciStarts d];
end

% find max and min values of TST
[minval, i] = min(weeklyMedianIntactLat);
disp(['Min sleep time: ' num2str(minval)])
datestr(weekIntactStarts(i))

[maxval, i] = max(weeklyMedianIntactLat);
disp(['Max sleep time: ' num2str(maxval)])
datestr(weekIntactStarts(i))

%%%%%%%%%%%%%%%%%%%
% find max and min values of TST
[minval, i] = min(weeklyMedianAmciLat);
disp(['Min sleep time: ' num2str(minval)])
datestr(weekAmciStarts(i))

[maxval, i] = max(weeklyMedianAmciLat);
disp(['Max sleep time: ' num2str(maxval)])
datestr(weekAmciStarts(i))

%%%%%%%%%%%%%%%%%%%%%
[minval, i] = min(weeklyMedianNamciLat);
disp(['Min sleep time: ' num2str(minval)])
datestr(weekNamciStarts(i))

[maxval, i] = max(weeklyMedianNamciLat);
disp(['Max sleep time: ' num2str(maxval)])
datestr(weekNamciStarts(i))


figure
subplot(3,1,1)
title('Intact Sleep Latency')
plot(weekIntactStarts, weeklyMedianIntactLat)
datetick('x', 12)

subplot(3,1,2)
title('aMCI Sleep Latency')
plot(weekAmciStarts, weeklyMedianAmciLat)
datetick('x',12)

subplot(3,1,3)
title('naMCI Sleep Latency')
plot(weekNamciStarts, weeklyMedianNamciLat)
datetick('x', 12)