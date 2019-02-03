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

% We're only go to use data between Jan 1, 2016 and June 30, 2016
jan2015 = datenum([2015 1 1 0 0 0]);
jun2015 = datenum([2015 6 30 23 59 59]);
jun2016 = datenum([2016 6 30 23 59 59]);
oct2016 = datenum([2016 10 30 0 0 0]);
% Set up arrays to hold the sums of the weekly median values and the number
% to divide each sum by to obtain the average
numWeeks = 53;
sumIntactMedianValue = zeros(1, numWeeks);
numIntactDivisor  = zeros(1, numWeeks);
varianceIntact = [];

sumAmnesticMedianValue = zeros(1, numWeeks);
numAmnesticDivisor  = zeros(1, numWeeks);
varianceAmnestic = [];

sumNonamnesticMedianValue = zeros(1, numWeeks);
numNonamnesticDivisor  = zeros(1, numWeeks);
varianceNonamenstic = [];

intactTST = [];
amnesticTST = [];
nonamnesticTST = [];

% Loop through all of the OADC numbers 
n = 1;
%for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = 11034 '];
    query4 = 'AND SensorSource = 2 ';
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    % get rid of rows where TST == 0
    del = find(qTST == 0);
    qdate(del) = [];
    qTST(del) = [];
    % trim our values to be between Jan and Jun 2016
    keep = find(qdate >= jan2015 & qdate <= oct2016);
    qdate = qdate(keep);
    % convert TST to hours
    qTST = qTST(keep)/3600;
    
    if mci(n) == 0
        intactTST = [intactTST qTST'];
    else
        if amci(n) == 1
            amnesticTST = [amnesticTST qTST'];
        else
            nonamnesticTST = [nonamnesticTST qTST'];
        end
    end
    
    % Loop through weeks between Jan and June 2016
    medianWeeklyValue = [];
    for d = jan2015 : 7 : oct2016
        % find all TST values for this week
        weekTSTIndices = find(qdate > d & qdate < d + 7);
        weeklyValues = qTST(weekTSTIndices);
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
%end

% Calculate the average values of TST for each week.
IntactAverageMedianValue = sumIntactMedianValue./numIntactDivisor;
AmnesticAverageMedianValue = sumAmnesticMedianValue./numAmnesticDivisor;
NonamnesticAverageMedianValue = sumNonamnesticMedianValue./numNonamnesticDivisor;
mysql('close')

intactTST(isnan(intactTST)) = [];
intactTST(intactTST > 12) = [];
amnesticTST(isnan(amnesticTST)) = [];
nonamnesticTST(isnan(nonamnesticTST)) = [];

intactStd = std(intactTST);
amnesticVar = var(amnesticTST);
nonamnesticVar = var(nonamnesticTST);


intactDates = linspace(jun2015, jun2016, length(IntactAverageMedianValue));
AmnesticDates = linspace(jun2015, jun2016, length(AmnesticAverageMedianValue));
NonamnesticDates = linspace(jun2015, jun2016, length(NonamnesticAverageMedianValue));

figure
hold on
plot(intactDates, IntactAverageMedianValue, '.-')
plot(AmnesticDates, AmnesticAverageMedianValue, '.-')
plot(NonamnesticDates, NonamnesticAverageMedianValue, '.-')
legend('Intact', 'Amnestic', 'Nonamnestic')
title('Total Sleep Time')
datetick('x')
xlim([intactDates(1) intactDates(end)])
ylabel('Hours')

intactCount = 0;
amnesticCount = 0;
nonamnesticCount = 0;

for n = 1 : length(oadc)
    if mci(n) == 0 
        intactCount = intactCount + 1;
    else
        % Generate the running sum for amnestic MCI
        if amci(n) == 1
            amnesticCount = amnesticCount + 1;
        % and for non-amnestic MCI
        else
            nonamnesticCount = nonamnesticCount + 1;
        end
    end
end

disp(['Intact: ' num2str(intactCount)])
disp(['Amnestic MCI: ' num2str(amnesticCount)])
disp(['Nonamnestic MCI: ' num2str(nonamnesticCount)])