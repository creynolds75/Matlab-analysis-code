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

NYCEdate = [];
NYCETST = [];
X10date = [];
X10TST = [];

n = 110;

% get total time asleep (TST) where SensorSource = 2, for NYCE data
query1 = 'SELECT Date, SleepTST ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 2 '];
query = [query1 query2 query3 query4];
[qdate, qTST] = mysql(query);

NYCETST = [NYCETST qTST'/3600];
NYCEdate = [NYCEdate qdate'];
    
query1 = 'SELECT Date, SleepTST ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 1 '];
query = [query1 query2 query3 query4];
[qdate, qTST] = mysql(query);

X10TST = [X10TST qTST'/3600];
X10date = [X10date qdate'];

date1 = datenum([2015 1 23 0 0 0]);
date2 = datenum([2015 10 7 0 0 0]);
del = find(NYCEdate < date1 | NYCEdate > date2);
NYCEdate(del) = [];
NYCETST(del) = [];
del = find(X10date < date1 | X10date > date2);
X10date(del) = [];
X10TST(del) = [];
del = find(NYCETST == 0 | NYCETST > 15);
NYCEdate(del) = [];
NYCETST(del) = [];
del = find(X10TST == 0 | X10TST > 15);
X10date(del) = [];
X10TST(del) = [];

figure
hold on
plot(X10date, X10TST, '.-')
plot(NYCEdate, NYCETST, '.-')
legend('X10', 'NYCE')
datetick('x', 12)
title(['Total sleep time - OADC ' num2str(oadc(n))])
ylabel('Hours')

n = 110;
NYCESL = [];
NYCEdate = [];
X10SL = [];
X10date = [];
% get total time asleep (TST) where SensorSource = 2, for NYCE data
query1 = 'SELECT Date, SleepLatency ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 2 '];
query = [query1 query2 query3 query4];
[qdate, qSL] = mysql(query);

NYCESL = [NYCESL qSL'/3600];
NYCEdate = [NYCEdate qdate'];

query1 = 'SELECT Date, SleepLatency ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 1 '];
query = [query1 query2 query3 query4];
[qdate, qSL] = mysql(query);

X10SL = [X10SL qSL'/3600];
X10date = [X10date qdate'];


date1 = datenum([2015 1 23 0 0 0]);
date2 = datenum([2015 10 7 0 0 0]);
del = find(NYCEdate < date1 | NYCEdate > date2);
NYCEdate(del) = [];
NYCESL(del) = [];
del = find(X10date < date1 | X10date > date2);
X10date(del) = [];
X10SL(del) = [];
del = find(NYCETST == 0 | NYCETST > 15);
NYCEdate(del) = [];
NYCESL(del) = [];
del = find(X10SL == 0 | X10SL > 15);
X10date(del) = [];
X10SL(del) = [];

figure
hold on
plot(X10date, X10SL, '.-')
plot(NYCEdate, NYCESL, '.-')
legend('X10', 'NYCE')
datetick('x', 12)
title(['Sleep latency - OADC ' num2str(oadc(n))])
ylabel('Hours')

 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NYCEdate = [];
NYCEWASO = [];
X10date = [];
X10WASO = [];
% % Loop through all of the OADC numbers 
n = 110;
% get total time asleep (TST) where SensorSource = 2, for NYCE data
query1 = 'SELECT Date, SleepWASO ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 2 '];
query = [query1 query2 query3 query4];
[qdate, qWASO] = mysql(query);

NYCEWASO = [NYCEWASO qWASO'/3600];
NYCEdate = [NYCEdate qdate'];

query1 = 'SELECT Date, SleepWASO ';
query2 = 'FROM algorithm_results.summary ';
query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
query4 = ['AND SensorSource = 1 '];
query = [query1 query2 query3 query4];
[qdate, qWASO] = mysql(query);

X10WASO = [X10WASO qWASO'/3600];
X10date = [X10date qdate'];


date1 = datenum([2015 1 23 0 0 0]);
date2 = datenum([2015 10 7 0 0 0]);
del = find(NYCEdate < date1 | NYCEdate > date2);
NYCEdate(del) = [];
NYCEWASO(del) = [];
del = find(X10date < date1 | X10date > date2);
X10date(del) = [];
X10WASO(del) = [];
del = find(NYCEWASO > 15);
NYCEdate(del) = [];
NYCEWASO(del) = [];
del = find(X10WASO > 15);
X10date(del) = [];
X10WASO(del) = [];
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
plot(X10date, X10WASO, '.-')
plot(NYCEdate, NYCEWASO, '.-')
legend('X10', 'NYCE')
datetick('x', 12)
title(['Wake after sleep onset - OADC ' num2str(oadc(n))])
ylabel('Hours')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NYCEdate = NYCEdate(1:256);
NYCETST = NYCETST(1:256);
NYCEWASO = NYCEWYSE(1:256);
NYCESL = NYCESL(1:256);


% 
% weeklyDates = [];
% weeklyMedianX10 = [];
% weeklyMedianNYCE = [];
% for n = date1:7:date2-7
%     weeklyDates = [weeklyDates n];
%     week = find(X10date >= n & X10date <= n+6);
%     weeklyMedianX10 = [weeklyMedianX10 median(X10WASO(week), 'omitnan')];
%     
%     week = find(NYCEdate >=n & NYCEdate <= n+6);
%     weeklyMedianNYCE = [weeklyMedianNYCE median(NYCEWASO(week), 'omitnan')];
% end
% 
% figure 
% hold on
% plot(weeklyDates, weeklyMedianX10, '.-')
% plot(weeklyDates, weeklyMedianNYCE, '.-')
% datetick('x', 12)
% legend('X10', 'NYCE')
% ylabel('Hours')
% title('Weekly median wake after sleep onset')
% 
% weeklyWASONYCE = weeklyMedianNYCE;
% weeklyWASOX10 = weeklyMedianX10;
% 
% disp(['Average NYCE WASO: ' num2str(mean(weeklyWASONYCE))])
% disp(['Average X10 WASO: ' num2str(mean(weeklyWASOX10))])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% weeklyTIBX10 = weeklyTSTX10 + weeklyMedianX10 + weeklyWASOX10;
% weeklyTIBNYCE = weeklyTSTNYCE + weeklyMedianNYCE + weeklyWASONYCE;
% 
% disp(['Average NYCE TIB: ' num2str(mean(weeklyTIBNYCE))])
% disp(['Average X10 TIB: ' num2str(mean(weeklyTIBX10))])
% 
% figure 
% hold on
% plot(weeklyDates, weeklyTIBX10, '.-')
% plot(weeklyDates, weeklyTIBNYCE, '.-')
% datetick('x', 12)
% legend('X10', 'NYCE')
% ylabel('Hours')
% title('Weekly median time in bed (TST + WASO + Sleep Latency)')