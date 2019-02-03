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
mciTST = [];
mcidate = [];
 
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
        mciTST = [mciTST qTST'];
        mcidate = [mcidate qdate'];
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

weeklyMedianMciTST = [];
weekMciStarts = [];
for d = min(mcidate)+21:7:max(mcidate)
    thisweek = find(mcidate >= d & mcidate < d+7);
    weeklyMedianMciTST = [weeklyMedianMciTST median(mciTST(thisweek), 'omitnan')];
    weekMciStarts = [weekMciStarts d];
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
[minval, i] = min(weeklyMedianMciTST);
disp(['Min sleep time MCI: ' num2str(minval)])
datestr(weekMciStarts(i))

[maxval, i] = max(weeklyMedianMciTST);
disp(['Max sleep time MCI: ' num2str(maxval)])
datestr(weekMciStarts(i))

figure
subplot(3,1,1)
plot(weekIntactStarts, weeklyMedianIntactTST, '.-')
title('Intact')
datetick('x',12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylim([7 8])

subplot(3,1,2)
plot(weekMciStarts, weeklyMedianMciTST, '.-')
title('MCI')
datetick('x',12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylim([7 9])

L = 45.5231;
for J=44:(365+365)
    %CBM Model
    theta=0.2163108+2*atan(0.9671396*tan(0.00860*(J-186))); %revolution angle from day of the year
    P = asin(0.39795*cos(theta)); %sun declination angle 
    %daylength (plus twilight)- 
    p=0.8333; %sunrise/sunset is when the top of the sun is apparently even with horizon
    D(J) = 24 - (24/pi) * acos((sin(p*pi/180)+sin(L*pi/180)*sin(P))/(cos(L*pi/180)*cos(P))); 
end
