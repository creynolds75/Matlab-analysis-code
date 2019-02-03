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

intactWASO = [];
amnesticWASO = [];
nonamnesticWASO = [];

for n = 1 : length(oadc)
    % get sleep values where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepWASO ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qWASO] = mysql(query);
    % get rid of rows where TST == 0
    del = find(qWASO == 0);
    qdate(del) = [];
    qWASO(del) = [];
    % trim our values to be between Jan and Jun 2016
    keep = find(qdate >= jun2015 & qdate <= jun2016);
    qdate = qdate(keep);
    % convert WASO to minutes
    qWASO = qWASO(keep)/60;
    
    if mci(n) == 0
        intactWASO = [intactWASO qWASO'];
    else
        if amci(n) == 1
            amnesticWASO = [amnesticWASO qWASO'];
        else
            nonamnesticWASO = [nonamnesticWASO qWASO'];
        end
    end
   
    % Loop through weeks between Jan and June 2016
    medianWeeklyValue = [];
    week = 0;
    for d = jun2015 : 7 : jun2016
        % find all TST values for this week
        weekWASOIndices = find(qdate > d & qdate < d + 7);
        medianWeeklyValue = [medianWeeklyValue var(qWASO(weekWASOIndices))];
    end
    % Replace NaNs with zeros
   % medianWeeklyValue(isnan(medianWeeklyValue)) = 0;
    
    % Calculate average median value for normal patients
    if mci(n) == 0 
        for j = 1 : length(medianWeeklyValue)
            if ~isnan(medianWeeklyValue(j))
                sumIntactMedianValue(j) = sumIntactMedianValue(j) + medianWeeklyValue(j);
                numIntactDivisor(j) = numIntactDivisor(j) + 1;
            end
        end
    else
        if amci(n) == 1
            for j = 1 : length(medianWeeklyValue)
                if ~isnan(medianWeeklyValue(j))
                    sumAmnesticMedianValue(j) = sumAmnesticMedianValue(j) + medianWeeklyValue(j);
                    numAmnesticDivisor(j) = numAmnesticDivisor(j) + 1;
                end
            end
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

IntactAverageMedianValue = sumIntactMedianValue./numIntactDivisor;
AmnesticAverageMedianValue = sumAmnesticMedianValue./numAmnesticDivisor;
NonamnesticAverageMedianValue = sumNonamnesticMedianValue./numNonamnesticDivisor;
mysql('close')

intactWASO(isnan(intactWASO)) = [];
amnesticWASO(isnan(amnesticWASO)) = [];
nonamnesticWASO(isnan(nonamnesticWASO)) = [];

intactVar = var(intactWASO);
amnesticVar = var(amnesticWASO);
nonamnesticVar = var(nonamnesticWASO);

figure
hold on

intactDates = linspace(jun2015, jun2016, length(IntactAverageMedianValue));
AmnesticDates = linspace(jun2015, jun2016, length(AmnesticAverageMedianValue));
NonamnesticDates = linspace(jun2015, jun2016, length(NonamnesticAverageMedianValue));

plot(intactDates, IntactAverageMedianValue, '.-')
plot(AmnesticDates, AmnesticAverageMedianValue, '.-')
plot(NonamnesticDates, NonamnesticAverageMedianValue, '.-')
legend('Intact', 'Amnestic', 'Nonamnestic')
title('Weekly Variance in Wake after Sleep Onset')
datetick('x')
xlim([intactDates(1) intactDates(end)])
ylabel('Minutes')