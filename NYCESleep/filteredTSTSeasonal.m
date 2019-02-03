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

figure
hold on
intactTST = [];
intactDate = [];

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
    if mci(n) == 0
        intactTST = [intactTST qTST'];
        intactDate = [intactDate qdate'];  
    end
end
meanTST = mean(intactTST, 'omitnan');
dev = std(intactTST, 'omitnan');

figure
hold on
TST = [];
dates = [];
for n = 1 : length(oadc)
    if mci(n) == 0
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
        qdate(outliers) =[];
        qTST(outliers) = [];
        TST = [TST qTST'];
        dates = [dates qdate'];
        
    end
end
datetick('x', 12)
ylabel('Hours')
title('Total Time Asleep')

AverageDailySleep = [];
sleepDates = [];
for d = min(dates):max(dates)
    thisdayIndices = find(dates == d);
    thisDaySleep = mean(TST(thisdayIndices), 'omitnan');
    AverageDailySleep = [AverageDailySleep thisDaySleep];
    sleepDates = [sleepDates d];
end

aug15 = datenum([2015 8 31 0 0 0]);
sept16 = datenum([2016 9 1 0 0 0]);

