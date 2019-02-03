
headers = {'OADC', 'Mean Sleep Time', 'Start Date', 'End Date', 'Group'};
filename =  'APOEmeansleeptimes.xlsx';
xlswrite(filename, headers);
rownum = 2;

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
std22or23 = [];
std33 = [];
std4 = [];
MCIstd = [];
numpts22or23 = 0;
numpts33 = 0;
numpts4 = 0;
numptsMCI = 0;
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
    % select only one year of data
    start = min(qdate);
    stop = start + 365;
    i = find(qdate > start & qdate < stop);
    qTST = qTST(i);
     meanTST = mean(qTST);
     stdTST = std(qTST);
     numpts = length(qTST);
     if meanTST >= 4
    if vstCDR(n) == 0       
        if strcmp(SPCgene1{n}, '2,2') | strcmp(SPCgene1{n}, '2,3')
            sleep22or23 = [sleep22or23 meanTST];
            std22or23 = [std22or23 stdTST];
            numpts22or23 = numpts22or23 + numpts;
            group = '2,2 or 2,3';
        elseif strcmp(SPCgene1{n}, '3,3')
            sleep33 = [sleep33 meanTST];
            std33 = [std33 meanTST];
            numpts33 = numpts33 + numpts;
            group = '3,3';
        elseif ~isempty(strfind(SPCgene1{n}, '4'))
            sleep4 = [sleep4 meanTST];
            std4 = [std4 stdTST];
            numpts4 = numpts4 + numpts;
            group = '4';
        end
    elseif vstCDR(n) == 0.5
        MCIsleep = [MCIsleep meanTST];
        numptsMCI = numptsMCI + numpts;
        MCIstd = [MCIstd stdTST];
        group = 'MCI';
    end
    row = {OADC(n), meanTST, datestr(start), datestr(stop), group};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
     end
end
mysql('close')

meanSleep22or23 = mean(sleep22or23, 'omitNaN');
meanSleep33 = mean(sleep33, 'omitNaN');
meanSleep4 = mean(sleep4, 'omitNaN');
meanSleepMCI = mean(MCIsleep, 'omitNaN');

meanSTD22or23 = mean(std22or23)
meanSTD33 = mean(std33)
meanSTD4 = mean(std4)
meanSTDMCI = mean(MCIstd)

% output results
disp(['Mean 22 or 23: ' num2str(meanSleep22or23)])
disp(['meanSleep33: ' num2str(meanSleep33)])
disp(['meanSleep4: ' num2str(meanSleep4)])
disp(['meanSleepMCI: ' num2str(meanSleepMCI)])
disp(['num of subjects 22 or 23 ' num2str(length(sleep22or23))])
disp(['num of subjects 33 ' num2str(length(sleep33))])
disp(['num of subjects sleep 4 ' num2str(length(sleep4))])
disp(['num of subjects MCI ' num2str(length(MCIsleep))])

disp(['num of data pts 22 or 23 ' num2str(numpts22or23)])
disp(['num of data pts 33 ' num2str(numpts33)])
disp(['num of data pts sleep 4 ' num2str(numpts4)])
disp(['num of data pts MCI ' num2str(numptsMCI)])