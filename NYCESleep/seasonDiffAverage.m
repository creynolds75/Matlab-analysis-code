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

% get OADC numbers
intactDiff = [];
amciDiff = [];
namciDiff = [];
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    
    winter1 = datenum([2016 1 15 0 0 0]);
    winter2 = datenum([2016 2 15 0 0 0]);
    winter = find(qdate > winter1 & qdate < winter2);
    wintersleep = qTST(winter);
    summer1 = datenum([2016 06 15 0 0 0]);
    summer2 = datenum([2016 07 15 0 0 0]);
    summer = find(qdate > summer1 & qdate < summer2);
    summersleep = qTST(summer);
    if ~isempty(wintersleep) & ~isempty(summersleep)
        meanwintersleep = mean(wintersleep, 'omitnan');
        meansummersleep = mean(summersleep, 'omitnan');
        difference = meanwintersleep - meansummersleep;
        disp(['CDR: ' num2str(vstCDR(n)) ' Diff: ' num2str(difference)]);
        if mci(n) == 0 
            intactDiff = [intactDiff difference];
        else
            if amci(n) == 1
                amciDiff = [amciDiff difference];
            else
                namciDiff = [namciDiff difference];
            end
        end
    end
end