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

intactTST = [];
amnesticTST = [];
nonamnesticTST = [];

intactDates = [];
amnesticDates = [];
nonamnesticDates = [];

% Loop through all of the OADC numbers 
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    % get rid of rows where TST == 0
    del = find(qTST == 0);
    qdate(del) = [];
    qTST(del) = [];

    % convert TST to hours
    qTST = qTST/3600;
    
    if mci(n) == 0
        intactTST = [intactTST qTST'];
        intactDates = [intactDates qdate'];
    else
        if amci(n) == 1
            amnesticTST = [amnesticTST qTST'];
            amnesticDates = [amnesticDates qdate'];
        else
            nonamnesticTST = [nonamnesticTST qTST'];
            nonamnesticTST = [nonamnesticDates qdate'];
        end
    end
end
mysql('close')

intactDates(isnan(intactTST)) = [];
intactTST(isnan(intactTST)) = [];
intactDates(intactTST > 12) = [];
intactTST(intactTST > 12) = [];

amnesticDates(isnan(amnesticTST)) = [];
amnesticTST(isnan(amnesticTST)) = [];

nonamnesticDates(isnan(nonamnesticTST)) = [];
nonamnesticTST(isnan(nonamnesticTST)) = [];
%
 figure
 hold on
 plot(intactDates, intactTST, '.')
 plot(amnesticDates, amnesticTST, '.')
 plot(nonamnesticDates, nonamnesticTST, '.')
% plot(intactDates, IntactAverageMedianValue, '.-')
% plot(AmnesticDates, AmnesticAverageMedianValue, '.-')
% plot(NonamnesticDates, NonamnesticAverageMedianValue, '.-')
legend('Intact (98)', 'Amnestic (8)', 'Nonamnestic (22)')
% title('Total Sleep Time - NYCE')
% datetick('x')
% xlim([intactDates(1) intactDates(end)])
% ylabel('Hours')
% 
% intactCount = 0;
% amnesticCount = 0;
% nonamnesticCount = 0;
% 
% for n = 1 : length(oadc)
%     if mci(n) == 0 
%         intactCount = intactCount + 1;
%     else
%         % Generate the running sum for amnestic MCI
%         if amci(n) == 1
%             amnesticCount = amnesticCount + 1;
%         % and for non-amnestic MCI
%         else
%             nonamnesticCount = nonamnesticCount + 1;
%         end
%     end
% end
% 
% disp(['Intact: ' num2str(intactCount)])
% disp(['Amnestic MCI: ' num2str(amnesticCount)])
% disp(['Nonamnestic MCI: ' num2str(nonamnesticCount)])