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
intactdate = [];
namciTST = [];
namcidate = [];
amciTST = [];
amcidate = [];
 
figure
hold on
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepWake ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qwake] = mysql(query);
    plot(qdate, qwake*24, '.')
%     qTST = qTST/3600;
%     del = find(qTST > 24 | qTST <= 0);
%     qTST(del) = [];
%     qdate(del) = [];
%     if mci(n) == 0 
%         intactTST = [intactTST qTST'];
%         intactdate = [intactdate qdate'];
%     else
%         if amci(n) == 1
%             amciTST = [amciTST qTST'];
%             amcidate = [amcidate qdate'];
%         else
%             namciTST = [namciTST qTST'];
%             namcidate = [namcidate qdate'];
%         end
%     end
end
mysql('close')