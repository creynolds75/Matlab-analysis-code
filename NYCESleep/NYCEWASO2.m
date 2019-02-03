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

sumIntactMedianValue = zeros(1, 26);
numIntactDivisor  = ones(1, 26);

sumAmnesticMedianValue = zeros(1, 26);
numAmnesticDivisor  = ones(1, 26);

sumNonamnesticMedianValue = zeros(1, 26);
numNonamnesticDivisor  = ones(1, 26);

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
    keep = find(qdate >= jan2016 & qdate <= jun2016);
    qdate = qdate(keep);
    % convert WASO to minutes
    qWASO = qWASO(keep)/60;
    

   
    % Loop through weeks between Jan and June 2016
    medianWeeklyValue = [];
    week = 0;
    for d = jan2016 : 7 : jun2016
        % find all TST values for this week
        weekWASOIndices = find(qdate > d & qdate < d + 7);
        medianWeeklyValue = [medianWeeklyValue median(qWASO(weekWASOIndices))];
        
        if mci(n) == 0
            intactWASO = [intactWASO qWASO(weekWASOIndices)'];
        else
            if amci(n) == 1
                amnesticWASO = [amnesticWASO qWASO(weekWASOIndices)'];
            else
                nonamnesticWASO = [nonamnesticWASO qWASO(weekWASOIndices)'];
            end
        end
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

% intactWASO(isnan(intactWASO)) = [];
% amnesticWASO(isnan(amnesticWASO)) = [];
% nonamnesticWASO(isnan(nonamnesticWASO)) = [];
%intactWASO(intactWASO > 360) = [];

% intactVar = var(intactWASO, 'omitnan')
%intactVar = mean(abs(intactWASO - mean(intactWASO, 'omitnan')), 'omitnan');
intactWASO(isnan(intactWASO)) = [];
intactVar = sqrt(sum((intactWASO - mean(intactWASO)).^2)/(length(intactWASO)))

amnesticWASO(isnan(amnesticWASO)) = [];
amnesticVar = sqrt(sum((amnesticWASO - mean(amnesticWASO)).^2)/(length(amnesticWASO)))

figure
hold on
errorbar(IntactAverageMedianValue, intactVar*ones(size(IntactAverageMedianValue)))
% plot(IntactAverageMedianValue, '.-')
% plot(AmnesticAverageMedianValue, '.-')
% plot(NonamnesticAverageMedianValue, '.-')
%legend('Intact', 'Amnestic', 'Nonamnestic')
title('Wake after Sleep Onset')
xlabel('Week')
ylabel('Minutes')