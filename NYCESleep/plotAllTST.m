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
allTST = [];
allDate = [];

for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    allTST = [allTST qTST'];
    allDate = [allDate qdate'];
    
end

meanTST = mean(allTST, 'omitnan');
dev = std(allTST, 'omitnan');
length(allTST)
countOutliers = 0;
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    
    plot(qdate, qTST, '.')
    
    highoutliers = find(qTST > meanTST + 2*dev);
    plot(qdate(highoutliers), qTST(highoutliers), 'ko')
    
    lowoutliers = find(qTST < meanTST - 2*dev);
    plot(qdate(lowoutliers), qTST(lowoutliers), 'ko')
    
    % get rid of outliers
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qTST(outliers) = [];
    
end
countOutliers
xlim([min(allDate) max(allDate)]);
datetick('x', 12)
ylabel('Hours')
title('Total Time Asleep')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
plot(min(allDate)-1, 1, 'k.')
plot(min(allDate)-1, 1, 'r.')
plot(min(allDate)-1, 1, 'b.')
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    
    % get rid of outliers
     highoutliers = find(qTST > meanTST + 2*dev);
     lowoutliers = find(qTST < meanTST - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qTST(outliers) = [];
    
    if mci(n) == 0
        plot(qdate, qTST, 'k.')
    else
        if amci(n) == 1
            plot(qdate, qTST, 'r.')
        else
            plot(qdate, qTST, 'b.')
        end
    end
end

xlim([min(allDate) max(allDate)]);
ylim([2 14])
datetick('x', 12)
ylabel('Hours')
title('Total Time Asleep')

legend('Intact', 'aMCI', 'naMCI')
mysql('close')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intactTST = [];
intactDates = [];
amciTST = [];
amciDates = [];
namciTST = [];
namciDates = [];

MySQL.connect(Subjects.SERVER);
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    
    % get rid of outliers
     highoutliers = find(qTST > meanTST + 2*dev);
     lowoutliers = find(qTST < meanTST - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qTST(outliers) = [];
    
    for d = min(allDate):7:max(allDate)-7
        weekTSTIndices = find(qdate > d & qdate < d + 7);
        weeklyValues = qTST(weekTSTIndices);
        if mci(n) == 0
            intactTST = [intactTST median(weeklyValues)];
            intactDates = [intactDates d];
        else
            if amci(n) == 1
                amciTST = [amciTST median(weeklyValues)];
                amciDates = [amciDates d];
            else
                namciTST = [namciTST median(weeklyValues)];
                namciDates = [namciDates d];
            end
        end
    end

end
figure 
hold on
plot(intactDates, intactTST, 'k')
plot(amciDates, amciTST, 'r')
plot(namciDates, namciTST, 'b')
xlim([min(allDate) max(allDate)]);
ylim([2 14])
datetick('x', 12)
ylabel('Hours')
title('Total Time Asleep')

legend('Intact', 'aMCI', 'naMCI')
mysql('close')


