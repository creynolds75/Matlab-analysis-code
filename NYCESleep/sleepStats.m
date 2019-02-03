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
intactSL = [];
intactWASO = [];

amnesticTST = [];
amnesticSL = [];
amnesticWASO = [];

nonamnesticTST = [];
nonamnesticSL = [];
nonamnesticWASO = [];

allTST = [];
allSL = [];
allWASO = [];

for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST, SleepLatency, SleepWASO ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = 'AND SensorSource = 2 ';
    query = [query1 query2 query3 query4];
    [qdate, qTST, qSL, qWASO] = mysql(query);
    
    % get rid of rows where TST == 0
    del = find(qTST == 0 | qTST > 12*3600);
    qTST(del) = [];
    
    % get rid of rows where SL == 0
    del = find(qSL == 0 | qSL > 3*3600);
    qSL(del) = [];
    
    % convert TST to hours
    qTST = qTST/3600;
    
    % convert SL to min
    qSL = qSL/60;
    
    % convert SL to min
    qWASO = qWASO/60;
    
    allTST = [allTST qTST'];
    allSL = [allSL qSL'];
    allWASO = [allWASO qWASO'];
    
    if mci(n) == 0
        intactTST = [intactTST qTST'];
        intactSL = [intactSL qSL'];
        intactWASO = [intactWASO qWASO'];
    else
        if amci(n) == 1
            amnesticTST = [amnesticTST qTST'];
            amnesticSL = [amnesticSL qSL'];
            amnesticWASO = [amnesticWASO qWASO'];
        else
            nonamnesticTST = [nonamnesticTST qTST'];
            nonamnesticSL = [nonamnesticSL qSL'];
            nonamnesticWASO = [nonamnesticWASO qWASO'];
        end
    end
end
