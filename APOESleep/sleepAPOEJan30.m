
% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);
sleep22or23 = [];
sleep33 = [];
sleep4 = [];
MCIsleep = [];
for n = 1 : length(OADC)
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(OADC(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
     meanTST = mean(qTST);
    if vstCDR(n) == 0
       
        if strcmp(SPCgene1{n}, '2,2') | strcmp(SPCgene1{n}, '2,3')
            sleep22or23 = [sleep22or23 meanTST];
        elseif strcmp(SPCgene1{n}, '3,3')
            sleep33 = [sleep33 meanTST];
        elseif ~isempty(strfind(SPCgene1{n}, '4'))
            sleep4 = [sleep4 meanTST];
        end
    elseif vstCDR(n) == 0.5
        MCIsleep = [MCIsleep meanTST];
    end
end
mysql('close')

meanSleep22or23 = mean(sleep22or23, 'omitNaN');
meanSleep33 = mean(sleep33, 'omitNaN');
meanSleep4 = mean(sleep4, 'omitNaN');
meanSleepMCI = mean(MCIsleep, 'omitNaN');


% output results
disp(['Mean 22 or 23: ' num2str(meanSleep22or23)])
disp(['meanSleep33: ' num2str(meanSleep33)])
disp(['meanSleep4: ' num2str(meanSleep4)])
disp(['meanSleepMCI: ' num2str(meanSleepMCI)])
disp(['num of data pts 22 or 23 ' num2str(length(sleep22or23))])
disp(['num of data pts 33 ' num2str(length(sleep33))])
disp(['num of data pts sleep 4 ' num2str(length(sleep4))])
disp(['num of data pts MCI ' num2str(length(MCIsleep))])

