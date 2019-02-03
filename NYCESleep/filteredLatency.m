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
allLatency = [];
allDate = [];
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
    allLatency= [allLatency qLatency'];
    allDate = [allDate qdate'];  
end
meanLatency = mean(allLatency, 'omitnan');
dev = std(allLatency, 'omitnan');

length(allLatency)
countOutliers = 0;
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
    
    plot(qdate, qLatency, '.')
    
    highoutliers = find(qLatency > meanLatency + 2*dev);
    plot(qdate(highoutliers), qLatency(highoutliers), 'ko')
    
    lowoutliers = find(qLatency < meanLatency - 2*dev);
    plot(qdate(lowoutliers), qLatency(lowoutliers), 'ko')
    
    % get rid of outliers
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qLatency(outliers) = [];
    
end
countOutliers
xlim([min(allDate) max(allDate)]);
datetick('x', 12)
ylabel('Minutes')
title('Sleep Latency')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
plot(min(allDate)-1, 1, 'k.')
plot(min(allDate)-1, 1, 'r.')
plot(min(allDate)-1, 1, 'b.')
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
    
    % get rid of outliers
     highoutliers = find(qLatency > meanLatency + 2*dev);
     lowoutliers = find(qLatency < meanLatency - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qLatency(outliers) = [];
    
    if mci(n) == 0
        plot(qdate, qLatency, 'k.')
    else
        if amci(n) == 1
            plot(qdate, qLatency, 'r.')
        else
            plot(qdate, qLatency, 'b.')
        end
    end
end

xlim([min(allDate) max(allDate)]);
datetick('x', 12)
ylabel('Minutes')
title('Sleep Latency')

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
    
    % get rid of outliers
     highoutliers = find(qLatency > meanLatency + 2*dev);
     lowoutliers = find(qLatency < meanLatency - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qLatency(outliers) = [];
    
    % Loop through weeks between Jan and June 2016
    medianWeeklyValue = [];
    for d = min(allDate):7:max(allDate)-7
        % find all TST values for this week
        weekLatencyIndices = find(qdate > d & qdate < d + 7);
        weeklyValues = qLatency(weekLatencyIndices);
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
title('Sleep Latency')
datetick('x', 12)
ylabel('Minutes')
