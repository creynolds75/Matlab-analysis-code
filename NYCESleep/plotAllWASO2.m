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
title('Wake After Sleep Onset')

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
numWeeks = length(min(allDate):7:max(allDate)-7);
sumIntactMedianValue = zeros(1, numWeeks);
intactDates = zeros(1, numWeeks);
numIntactDivisor  = zeros(1, numWeeks);

sumAmnesticMedianValue = zeros(1, numWeeks);
amnesticDates = zeros(1, numWeeks);
numAmnesticDivisor  = zeros(1, numWeeks);

sumNonamnesticMedianValue = zeros(1, numWeeks);
nonAmnesticDates = zeros(1, numWeeks);
numNonamnesticDivisor  = zeros(1, numWeeks);

MySQL.connect(Subjects.SERVER);
% Loop through all of the OADC numbers 
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
    
    % Loop through weeks between Jan and June 2016
    medianWeeklyValue = [];
    for d = min(allDate):7:max(allDate)-7
        % find all TST values for this week
        weekWASOIndices = find(qdate > d & qdate < d + 7);
        weeklyValues = qWASO(weekWASOIndices);
        medianWeeklyValue = [medianWeeklyValue median(weeklyValues)];
    end
    
    % Calculate average median value for normal patients (MCI = 0)
    if mci(n) == 0 
        for j = 1 : length(medianWeeklyValue)
            % if there is a numeric value for that week, add it to the
            % running sum for that week. Also increment the number of
            % values in that sum for that week
            if ~isnan(medianWeeklyValue(j))
                sumIntactMedianValue(j) = sumIntactMedianValue(j) + medianWeeklyValue(j);
                numIntactDivisor(j) = numIntactDivisor(j) + 1;
                
            end
        end
    else
        % Generate the running sum for amnestic MCI
        if amci(n) == 1
            for j = 1 : length(medianWeeklyValue)
                if ~isnan(medianWeeklyValue(j))
                    sumAmnesticMedianValue(j) = sumAmnesticMedianValue(j) + medianWeeklyValue(j);
                    numAmnesticDivisor(j) = numAmnesticDivisor(j) + 1;
                end
            end
        % and for non-amnestic MCI
        else
            for j = 1 : length(medianWeeklyValue)
                if ~isnan(medianWeeklyValue(j))
                    sumNonamnesticMedianValue(j) = sumNonamnesticMedianValue(j) + medianWeeklyValue(j);
                    numNonamnesticDivisor(j) = numNonamnesticDivisor(j) + 1;
                    
                end
            end
        end
    end
end

% Calculate the average values of TST for each week.
IntactAverageMedianValue = sumIntactMedianValue./numIntactDivisor;
AmnesticAverageMedianValue = sumAmnesticMedianValue./numAmnesticDivisor;
NonamnesticAverageMedianValue = sumNonamnesticMedianValue./numNonamnesticDivisor;
dates = linspace(min(allDate), max(allDate)-7, numWeeks);
figure
hold on
plot(dates, IntactAverageMedianValue, '.-')
plot(dates, AmnesticAverageMedianValue, '.-')
plot(dates, NonamnesticAverageMedianValue, '.-')
xlim([dates(1) dates(end)])
legend('Intact', 'Amnestic', 'Nonamnestic')
title('Wake After Sleep Onset')
datetick('x', 12)
ylabel('Minutes')
