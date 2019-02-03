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
sleep22 = []; 
sleep23 = [];
sleep24 = [];
sleep33 = [];
sleep34 = [];
varsleep22 = [];
varsleep23 = [];
varsleep24 = [];
varsleep33 = [];
varsleep34 = [];
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
   if strcmp(intactAPOE{n}, '2,2')
       sleep22 = [sleep22 qTST'];
       varsleep22 = [varsleep22 std(qTST)];
   elseif strcmp(intactAPOE{n}, '2,3')
       sleep23 = [sleep23 qTST'];
       varsleep23 = [varsleep23 std(qTST)];
   elseif strcmp(intactAPOE{n}, '2,4')
       sleep24 = [sleep24 qTST'];
       varsleep24 = [varsleep24 std(qTST)];
   elseif strcmp(intactAPOE{n}, '3,3')
       sleep33 = [sleep33 qTST'];
   else
       sleep34 = [sleep34 qTST'];
   end
end
mysql('close')
disp(['2,2: ' num2str(mean(sleep22, 'omitnan'))]);
disp(['2,3: ' num2str(mean(sleep23, 'omitnan'))]);
disp(['2,4: ' num2str(mean(sleep24, 'omitnan'))]);
disp(['3,3: ' num2str(mean(sleep33, 'omitnan'))]);
disp(['3,4: ' num2str(mean(sleep34, 'omitnan'))]);

disp(['2,2: ' num2str(std(sleep22, 'omitnan'))]);
disp(['2,3: ' num2str(std(sleep23, 'omitnan'))]);
disp(['2,4: ' num2str(std(sleep24, 'omitnan'))]);
disp(['3,3: ' num2str(std(sleep33, 'omitnan'))]);
disp(['3,4: ' num2str(std(sleep34, 'omitnan'))]);

n22 = 0;
n23 = 0;
n24 = 0;
n33 = 0;
n34 = 0;
for n = 1 : length(intactAPOE)
     if strcmp(intactAPOE{n}, '2,2')
       n22 = n22+1;
   elseif strcmp(intactAPOE{n}, '2,3')
       n23 = n23+1;
   elseif strcmp(intactAPOE{n}, '2,4')
       n24 = n24+1;
   elseif strcmp(intactAPOE{n}, '3,3')
       n33 = n33+1;
   else
       n34 = n34+1;
   end
end
% 
% % loop through all the OADC numbers
% import Orcatech.MySQL
% import Orcatech.IdArray
% import Orcatech.Databases.Subjects
% import Orcatech.Databases.AlgorithmResults
% 
% o = Orcatech.Interface('dunch', 'Dunch!1');
% MySQL.connect(Subjects.SERVER);
% walk22 = []; 
% walk23 = [];
% walk24 = [];
% walk33 = [];
% walk34 = [];
% dates = [];
% for n = 1 : length(intactOADC)
%     % get total time asleep (TST) where SensorSource = 2, for NYCE data
%     query1 = 'SELECT Date, WalkSpeedMean ';
%     query2 = 'FROM algorithm_results.summary ';
%     query3 = ['WHERE OADC = ' num2str(intactOADC(n)) ' '];
%     query4 = ['AND SensorSource = 2 '];
%     query = [query1 query2 query3 query4];
%     [qdate, qwalk] = mysql(query);
%     dates = [dates qdate'];
%    if strcmp(intactAPOE{n}, '2,2')
%        walk22 = [walk22 qwalk'];
%    elseif strcmp(intactAPOE{n}, '2,3')
%        walk23 = [walk23 qwalk'];
%    elseif strcmp(intactAPOE{n}, '2,4')
%        walk24 = [walk24 qwalk'];
%    elseif strcmp(intactAPOE{n}, '3,3')
%        walk33 = [walk33 qwalk'];
%    else
%        walk34 = [walk34 qwalk'];
%    end
% end
% mysql('close')
% disp(['2,2: ' num2str(mean(walk22, 'omitnan'))]);
% disp(['2,3: ' num2str(mean(walk23, 'omitnan'))]);
% disp(['2,4: ' num2str(mean(walk24, 'omitnan'))]);
% disp(['3,3: ' num2str(mean(walk33, 'omitnan'))]);
% disp(['3,4: ' num2str(mean(walk34, 'omitnan'))]);
% 
% 
% o = Orcatech.Interface('dunch', 'Dunch!1');
% MySQL.connect(Subjects.SERVER);
% waso22 = []; 
% waso23 = [];
% waso24 = [];
% waso33 = [];
% waso34 = [];
% dates = [];
% for n = 1 : length(intactOADC)
%     % get total time asleep (TST) where SensorSource = 2, for NYCE data
%     query1 = 'SELECT Date, SleepWASO ';
%     query2 = 'FROM algorithm_results.summary ';
%     query3 = ['WHERE OADC = ' num2str(intactOADC(n)) ' '];
%     query4 = ['AND SensorSource = 2 '];
%     query = [query1 query2 query3 query4];
%     [qdate, qwaso] = mysql(query);
%     dates = [dates qdate'];
%    if strcmp(intactAPOE{n}, '2,2')
%        waso22 = [waso22 qwaso'];
%    elseif strcmp(intactAPOE{n}, '2,3')
%        waso23 = [waso23 qwaso'];
%    elseif strcmp(intactAPOE{n}, '2,4')
%        waso24 = [waso24 qwaso'];
%    elseif strcmp(intactAPOE{n}, '3,3')
%        waso33 = [waso33 qwaso'];
%    else
%        waso34 = [waso34 qwaso'];
%    end
% end
% mysql('close')
% disp(['2,2: ' num2str(mean(waso22, 'omitnan'))]);
% disp(['2,3: ' num2str(mean(waso23, 'omitnan'))]);
% disp(['2,4: ' num2str(mean(waso24, 'omitnan'))]);
% disp(['3,3: ' num2str(mean(waso33, 'omitnan'))]);
% disp(['3,4: ' num2str(mean(waso34, 'omitnan'))]);