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
allUP = [];
allDate = [];
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTripsOut ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qUP] = mysql(query);

    del = find(qUP < 0);
    qUP(del) = [];
    qdate(del) = [];
    allUP = [allUP qUP'];
    allDate = [allDate qdate'];  
end
meanUP = mean(allUP, 'omitnan');
dev = std(allUP, 'omitnan');

length(allUP)
countOutliers = 0;
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTripsOut  ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qUP] = mysql(query);
  
    del = find(qUP < 0);
    qUP(del) = [];
    qdate(del) = [];
    
    plot(qdate, qUP, '.')
    
    highoutliers = find(qUP > meanUP + 2*dev);
    plot(qdate(highoutliers), qUP(highoutliers), 'ko')
    
    lowoutliers = find(qUP < meanUP - 2*dev);
    plot(qdate(lowoutliers), qUP(lowoutliers), 'ko')
    
    % get rid of outliers
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qUP(outliers) = [];
    
end
countOutliers
xlim([min(allDate) max(allDate)]);
datetick('x', 12)
title('Trips out of Bedroom')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
plot(min(allDate)-1, 1, 'k.')
plot(min(allDate)-1, 1, 'r.')
plot(min(allDate)-1, 1, 'b.')
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTripsOut ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qUP] = mysql(query);
    
    del = find(qUP < 0);
    qUP(del) = [];
    qdate(del) = [];
    
    % get rid of outliers
     highoutliers = find(qUP > meanUP + 2*dev);
     lowoutliers = find(qUP < meanUP - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qUP(outliers) = [];
    
    if mci(n) == 0
        plot(qdate, qUP, 'k.')
    else
        if amci(n) == 1
            plot(qdate, qUP, 'r.')
        else
            plot(qdate, qUP, 'b.')
        end
    end
end

xlim([min(allDate) max(allDate)]);
datetick('x', 12)
title('Trips out of Bedroom')

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
    query1 = 'SELECT Date, SleepTripsOut ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qUP] = mysql(query);

    del = find(qUP <= 0);
    qUP(del) = [];
    qdate(del) = [];
    
    % get rid of outliers
     highoutliers = find(qUP > meanUP + 2*dev);
     lowoutliers = find(qUP < meanUP - 2*dev);
    outliers = [highoutliers' lowoutliers'];
    countOutliers = countOutliers + length(outliers);
    qdate(outliers) =[];
    qUP(outliers) = [];
    
    % Loop through weeks between Jan and June 2016
    medianWeeklyValue = [];
    for d = min(allDate):7:max(allDate)-7
        % find all TST values for this week
        weekUPIndices = find(qdate > d & qdate < d + 7);
        weeklyValues = qUP(weekUPIndices);
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
title('Trips out of Bedroom')
datetick('x', 12)

