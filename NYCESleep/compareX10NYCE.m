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

intactTSTX10 = [];
intactTSTdateX10 = [];
intactTSTNYCE = [];
intactTSTdateNYCE = [];

intactLatX10 = [];
intactLatdateX10 = [];
intactLatNYCE = [];
intactLatdateNYCE = [];
 
%%% total sleep time
 for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qTSTdateX10, qTSTX10] = mysql(query);
    qTSTX10 = qTSTX10/3600;
    del = find(qTSTX10 > 24 | qTSTX10 <= 0);
    qTSTX10(del) = [];
    qTSTdateX10(del) = [];
    
    query1 = 'SELECT Date, SleepLatency ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qLatdateX10, qLatX10] = mysql(query);
    qLatX10 = qLatX10/3600;
    del = find(qLatX10 > 24 | qLatX10 <= 0);
    qLatX10(del) = [];
    qLatdateX10(del) = [];
    
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qTSTdateNYCE, qTSTNYCE] = mysql(query);
    qTSTNYCE = qTSTNYCE/3600;
    del = find(qTSTNYCE > 24 | qTSTNYCE <= 0);
    qTSTNYCE(del) = [];
    qTSTdateNYCE(del) = [];
    
        query1 = 'SELECT Date, SleepLatency ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qLatdateNYCE, qLatNYCE] = mysql(query);
    qLatNYCE = qLatNYCE/3600;
    del = find(qLatNYCE > 24 | qLatNYCE <= 0);
    qLatNYCE(del) = [];
    qLatdateNYCE(del) = [];
     
   if mci(n) == 0
        intactTSTX10 = [intactTSTX10 qTSTX10'];
        intactTSTdateX10 = [intactTSTdateX10 qTSTdateX10'];
        intactTSTNYCE = [intactTSTNYCE qTSTNYCE'];
        intactTSTdateNYCE = [intactTSTdateNYCE qTSTdateNYCE'];
        
        intactLatX10 = [intactLatX10 qLatX10'];
        intactLatdateX10 = [intactLatdateX10 qLatdateX10'];
        intactLatNYCE = [intactLatNYCE qLatNYCE'];
        intactLatdateNYCE = [intactLatdateNYCE qLatdateNYCE'];
   end
 end
 j = 1;
 jan15 = datenum([2015 1 1 0 0 0]);
 oct15 = datenum([2015 10 31 0 0 0]);
 for d = jan15 : oct15
    m = find(intactTSTdateX10 == d);
    n = find(intactTSTdateNYCE == d);
    
    if ~isempty(m) && ~isempty(n)
         totalDate(j) = d;
         %aveLatency = mean(intactLatency(m), 'omitnan');
         aveTSTX10(j) = mean(intactTSTX10(m), 'omitnan');
         aveTSTNYCE(j) = mean(intactTSTNYCE(n), 'omitnan');
         %totalTime(j) = aveTST + aveLatency;
         j = j + 1;
     end
 end
 
  for d = jan15 : oct15
    m = find(intactLatdateX10 == d);
    n = find(intactLatdateNYCE == d);
    
    if ~isempty(m) && ~isempty(n)
         totalDate(j) = d;
         %aveLatency = mean(intactLatency(m), 'omitnan');
         aveLatX10(j) = mean(intactLatX10(m), 'omitnan');
         aveLatNYCE(j) = mean(intactLatNYCE(n), 'omitnan');
         %totalTime(j) = aveTST + aveLatency;
         j = j + 1;
     end
 end
    