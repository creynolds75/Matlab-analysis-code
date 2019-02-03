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

date = [];
NYCEwalk = [];
X10walk = [];

% Loop through all of the OADC numbers 
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, WalkSpeedMedian ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdateNYCE, qwalkNYCE] = mysql(query);
    
    query1 = 'SELECT Date, WalkSpeedMedian ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qdateX10, qwalkX10] = mysql(query);
    
    
    % find the intersect between the two
    [~, NYCEi, X10i] = intersect(qdateNYCE, qdateX10);
    date = [date qdateNYCE(NYCEi)'];
    NYCEwalk = [NYCEwalk qwalkNYCE(NYCEi)'];
    X10walk = [X10walk qwalkX10(X10i)'];
    

end

    del = find(NYCEwalk > 100);
    date(del) = [];
    NYCEwalk(del) = [];
    X10walk(del) = [];
    
   del = find(X10walk > 100);
    date(del) = [];
    NYCEwalk(del) = [];
    X10walk(del) = [];
    
%     diff = abs(NYCEwalk - X10walk);
%     del = find(diff > 40);
%         NYCEwalk(del) = [];
%     X10walk(del) = [];
    
figure
plot(X10walk, NYCEwalk, '.')
xlabel('X10 Sensors (cm/sec)')
ylabel('NYCE Sensors (cm/sec)')
axis square 
xlim([0 100])
ylim([0 100])
