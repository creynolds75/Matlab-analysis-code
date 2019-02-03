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
jan2016 = datenum([2016 1 1 0 0 0]);
jun2016 = datenum([2016 6 30 23 59 59]);
jun2015 = datenum([2015 6 30 23 59 59]);

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

% Loop through all of the OADC numbers 
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, TransitionsCount ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTrans] = mysql(query);
    
    % get rid of rows where transitions == 0
    del = find(qTrans == 0);
    qdate(del) = [];
    qTrans(del) = [];
    % trim our values to be between Jan and Jun 2016
    keep = find(qdate >= jun2015 & qdate <= jun2016);
    qdate = qdate(keep);
    qTrans = qTrans(keep);
    
    medianWeeklyValue = [];
    for d = jun2015 : 7 : jun2016
        weekIndices = find(qdate > d & qdate < d + 7);
        medianWeeklyValue = [medianWeeklyValue median(qTrans(weekIndices))];
    end
    
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
mysql('close')

% Calculate the average values of TST for each week.
IntactAverageMedianValue = sumIntactMedianValue./numIntactDivisor;
AmnesticAverageMedianValue = sumAmnesticMedianValue./numAmnesticDivisor;
NonamnesticAverageMedianValue = sumNonamnesticMedianValue./numNonamnesticDivisor;


intactDates = linspace(jun2015, jun2016, length(IntactAverageMedianValue));
AmnesticDates = linspace(jun2015, jun2016, length(AmnesticAverageMedianValue));
NonamnesticDates = linspace(jun2015, jun2016, length(NonamnesticAverageMedianValue));

figure
hold on
plot(intactDates, IntactAverageMedianValue, '.-')
plot(AmnesticDates, AmnesticAverageMedianValue, '.-')
plot(NonamnesticDates, NonamnesticAverageMedianValue, '.-')
legend('Intact', 'Amnestic', 'Nonamnestic')
title('Number of Room Transitions')
datetick('x')
xlim([intactDates(1) intactDates(end)])
