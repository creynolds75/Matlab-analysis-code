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

jan2015 = datenum([2015 1 1 0 0 0]);
sept2016 = datenum([2016 9 19 0 0 0]);

figure
hold on
allWASO = [];
allDate = [];

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
    allWASO = [allWASO qWASO'];
    allDate = [allDate qdate'];
    
end

meanWASO = mean(allWASO, 'omitnan');
dev = std(allWASO, 'omitnan');
length(allWASO)
countOutliers = 0;
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
    
    plot(qdate, qWASO, '.')
    
    highoutliers = find(qWASO > meanWASO + 2*dev);
    plot(qdate(highoutliers), qWASO(highoutliers), 'ko')
    
    lowoutliers = find(qWASO < meanWASO - 2*dev);
    plot(qdate(lowoutliers), qWASO(lowoutliers), 'ko')
    
    % get rid of outliers
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qWASO(outliers) = [];
    
end
countOutliers
xlim([min(allDate) max(allDate)]);
datetick('x', 12)
ylabel('Minutes')
title('Awake after Sleep Onset')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
plot(min(allDate)-1, 1, 'k.')
plot(min(allDate)-1, 1, 'r.')
plot(min(allDate)-1, 1, 'b.')
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
    
    % get rid of outliers
     highoutliers = find(qWASO > meanWASO + 2*dev);
     lowoutliers = find(qWASO < meanWASO - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qWASO(outliers) = [];
    
    if mci(n) == 0
        plot(qdate, qWASO, 'k.')
    else
        if amci(n) == 1
            plot(qdate, qWASO, 'r.')
        else
            plot(qdate, qWASO, 'b.')
        end
    end
end

xlim([min(allDate) max(allDate)]);
datetick('x', 12)
ylabel('Minutes')
title('Wake after Sleep Onset')

legend('Intact', 'aMCI', 'naMCI')
mysql('close')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intactWASO = [];
intactDates = [];
amciWASO = [];
amciDates = [];
namciWASO = [];
namciDates = [];

MySQL.connect(Subjects.SERVER);
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
    
    % get rid of outliers
     highoutliers = find(qWASO > meanWASO + 2*dev);
     lowoutliers = find(qWASO < meanWASO - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qWASO(outliers) = [];
    
    for d = min(allDate):7:max(allDate)-7
        weekWASOIndices = find(qdate > d & qdate < d + 7);
        weeklyValues = qWASO(weekWASOIndices);
        if mci(n) == 0
            intactWASO = [intactWASO median(weeklyValues)];
            intactDates = [intactDates d];
        else
            if amci(n) == 1
                amciWASO = [amciWASO median(weeklyValues)];
                amciDates = [amciDates d];
            else
                namciWASO = [namciWASO median(weeklyValues)];
                namciDates = [namciDates d];
            end
        end
    end

end
figure 
hold on
plot(intactDates, intactWASO, 'k')
%plot(amciDates, amciWASO, 'r.')
%plot(namciDates, namciWASO, 'b.')
xlim([min(allDate) max(allDate)]);
datetick('x', 12)
ylabel('Minutes')
title('Wake after Sleep Onset')

legend('Intact', 'aMCI', 'naMCI')
mysql('close')

