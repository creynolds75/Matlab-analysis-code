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
intactdate = [];
namciTST = [];
namcidate = [];
amciTST = [];
amcidate = [];
 
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
    if mci(n) == 0 
        intactTST = [intactTST qTST'];
        intactdate = [intactdate qdate'];
    else
        if amci(n) == 1
            amciTST = [amciTST qTST'];
            amcidate = [amcidate qdate'];
        else
            namciTST = [namciTST qTST'];
            namcidate = [namcidate qdate'];
        end
    end
end
mysql('close')


weeklyMedianIntactTST = [];
weekIntactStarts = [];
for d = min(intactdate)+21:7:max(intactdate)
    thisweek = find(intactdate >= d & intactdate < d+7);
    weeklyMedianIntactTST = [weeklyMedianIntactTST median(intactTST(thisweek), 'omitnan')];
    weekIntactStarts = [weekIntactStarts d];
end

weeklyMedianAmciTST = [];
weekAmciStarts = [];
for d = min(amcidate)+21:7:max(amcidate)
    thisweek = find(amcidate >= d & amcidate < d+7);
    weeklyMedianAmciTST = [weeklyMedianAmciTST median(amciTST(thisweek), 'omitnan')];
    weekAmciStarts = [weekAmciStarts d];
end

weeklyMedianNamciTST = [];
weekNamciStarts = [];
for d = min(amcidate)+21:7:max(amcidate)
    thisweek = find(namcidate >= d & namcidate < d+7);
    weeklyMedianNamciTST = [weeklyMedianNamciTST median(namciTST(thisweek), 'omitnan')];
    weekNamciStarts = [weekNamciStarts d];
end

% find max and min values of TST
[minval, i] = min(weeklyMedianIntactTST);
disp(['Min sleep time intact: ' num2str(minval)])
datestr(weekIntactStarts(i))

[maxval, i] = max(weeklyMedianIntactTST);
disp(['Max sleep time intact: ' num2str(maxval)])
datestr(weekIntactStarts(i))

%%%%%%%%%%%%%%%%%%%
% find max and min values of TST
[minval, i] = min(weeklyMedianAmciTST);
disp(['Min sleep time aMCI: ' num2str(minval)])
datestr(weekAmciStarts(i))

[maxval, i] = max(weeklyMedianAmciTST);
disp(['Max sleep time aMCI: ' num2str(maxval)])
datestr(weekAmciStarts(i))

%%%%%%%%%%%%%%%%%%%%%
[minval, i] = min(weeklyMedianNamciTST);
disp(['Min sleep time naMCI: ' num2str(minval)])
datestr(weekNamciStarts(i))

[maxval, i] = max(weeklyMedianNamciTST);
disp(['Max sleep time naMCI: ' num2str(maxval)])
datestr(weekNamciStarts(i))


L = 45.5231;
for J=1:600
    %CBM Model
    theta=0.2163108+2*atan(0.9671396*tan(0.00860*(J-186))); %revolution angle from day of the year
    P = asin(0.39795*cos(theta)); %sun declination angle 
    %daylength (plus twilight)- 
    p=0.8333; %sunrise/sunset is when the top of the sun is apparently even with horizon
    D(J) = 24 - (24/pi) * acos((sin(p*pi/180)+sin(L*pi/180)*sin(P))/(cos(L*pi/180)*cos(P))); 
end