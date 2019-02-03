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
figure
hold on
count = 0;
% Loop through all of the OADC numbers 
for n = 1 : length(oadc)
   % if oadc(n) ~= 11149
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    % get rid of rows where TST == 0
    del = find(qTST == 0);
    qdate(del) = [];
    qTST(del) = [];
    % trim our values to be between Jan and Jun 2016
    keep = find(qdate >= jun2015 & qdate <= jun2016);
    qdate = qdate(keep);
    % convert TST to hours
    qTST = qTST(keep)/3600;
    qTST(qTST > 14) = [];
    
    % Calculate average median value for normal patients (MCI = 0)
    if mci(n) == 1 
        % Generate the running sum for amnestic MCI
        if amci(n) == 1
            plot(qTST, '.', 'MarkerSize', 12);
 
            disp(num2str(oadc(n)))
             pause
            count = count + 1;
        end
    end
   % end
end
