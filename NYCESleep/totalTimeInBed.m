%clear all
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
intactTSTdate = [];
intactLatency = [];
intactLatdate = [];
 
 for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qTSTdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qTSTdate(del) = [];
    
    query1 = 'SELECT Date, SleepLatency ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qLatdate, qLatency] = mysql(query);
    qLatency = qLatency/3600;
    del = find(qLatency > 24 | qLatency <= 0);
    qLatency(del) = [];
    qLatdate(del) = [];
    
   if mci(n) == 0
        intactLatency = [intactLatency qLatency'];
        intactLatdate = [intactLatdate qLatdate'];
        intactTST = [intactTST qTST'];
        intactTSTdate = [intactTSTdate qTSTdate'];
   end
 end
 j = 1;
  jan15 = datenum([2015 1 1 0 0 0]);
 oct15 = datenum([2015 10 31 0 0 0]);
 for d = min(intactTSTdate) : max(intactTSTdate)
%for d = jan15 : oct15
    m = find(intactLatdate == d);
    n = find(intactTSTdate == d);
    
    if ~isempty(m) && ~isempty(n)
         totalDate(j) = d;
         aveLatency = mean(intactLatency(m), 'omitnan');
         samplesLat(j) = length(~isnan(intactLatency(m)));
         aveTST = mean(intactTST(n), 'omitnan');
         samplesTST(j) = length(~isnan(intactTST(n)));
         totalTime(j) = aveTST + aveLatency;
         j = j + 1;
     end
 end
 
%  totalDate(1:30) = [];
%  totalTime(1:30) = [];
    
    