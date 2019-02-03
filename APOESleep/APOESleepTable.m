% Find the gene status for each OADC in the list of those with clinical
% data and sleep data
for n = 1 : length(OADC)
    i = find(Spatid == OADC(n));
    geneStatus(n) = SPCgene1(n);
end

% now collect those who are intact
intactOADC = [];
intactAPOE = [];
intactAge = [];
intactSex = [];
intactMMSE = [];
for n = 1 : length(OADC)
    if vstCDR(n) == 0
        intactOADC = [intactOADC OADC(n)];
        intactAPOE = [intactAPOE geneStatus(n)];
        intactAge = [intactAge VSTage(n)];
        intactSex = [intactSex Rsex(n)];
        intactMMSE = [intactMMSE vstMMSE(n)];
    end
end

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
dates = [];

for n = 1 : length(intactOADC)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(intactOADC(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    dates = [dates qdate'];
   if strcmp(intactAPOE{n}, '2,2') || strcmp(intactAPOE{n}, '2,3')
       sleep22or23 = [sleep22or23 qTST'];
   elseif strcmp(intactAPOE{n}, '3,3')
       sleep33 = [sleep33 qTST'];
   else
       sleep4 = [sleep4 qTST'];
   end
end