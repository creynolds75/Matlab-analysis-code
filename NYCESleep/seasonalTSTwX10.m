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
 numIntact = 0;
 numAmci = 0;
 numNamci = 0;
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    if mci(n) == 0 
        intactTST = [intactTST qTST'];
        intactdate = [intactdate qdate'];
        numIntact = numIntact + 1;
    else
        if amci(n) == 1
            amciTST = [amciTST qTST'];
            amcidate = [amcidate qdate'];
            numAmci = numAmci + 1;
        else
            namciTST = [namciTST qTST'];
            namcidate = [namcidate qdate'];
            numNamci = numNamci + 1;
        end
    end
end

mysql('close')

intactdates = min(intactdate):max(intactdate);
dailyAverageIntact = [];

for d = min(intactdate):max(intactdate)
    thisday = find(intactdate == d);
    dailyAverageIntact = [dailyAverageIntact median(intactTST(thisday), 'omitnan')];
end
intactdates = intactdates(30:end);
dailyAverageIntact = dailyAverageIntact(30:end);

amcidates = min(amcidate):max(amcidate);
dailyAverageAmci = [];

for d = min(amcidate):max(amcidate)
    thisday = find(amcidate == d);
    dailyAverageAmci = [dailyAverageAmci median(amciTST(thisday), 'omitnan')];
end

namcidates = min(namcidate):max(namcidate);
dailyAverageNamci = [];

for d = min(namcidate):max(namcidate)
    thisday = find(namcidate == d);
    dailyAverageNamci = [dailyAverageNamci median(namciTST(thisday), 'omitnan')];
end

figure
subplot(3,1,1)
plot(intactdates, dailyAverageIntact,'.')
title(['Cognitively Intact: ' num2str(numIntact) ' subjects'])
datetick('x', 12)
ylim([4 12])
xlim([intactdates(1) intactdates(end)]);
hold on
p1 = -1.655e-23;
p2 = 1.922e-16;
p3 = -3.992e-10;
p4 = 0.0002657;
p5 = 17.25;
p6 = -8.114e7;
p7 = 2.27e13;
fit = p1*intactdates.^6 + p2*intactdates.^5 + p3*intactdates.^4 ...
    + p4*intactdates.^3 + p5*intactdates.^2 + p6*intactdates + p7;

plot(intactdates, fit, 'r')

subplot(3,1,2)
plot(amcidates, dailyAverageAmci,'.')
title(['Amnestic MCI: ' num2str(numAmci) ' subjects'])
datetick('x', 12)
ylim([4 12])
xlim([intactdates(1) intactdates(end)]);

subplot(3,1,3)
plot(namcidates, dailyAverageNamci, '.')
title(['Nonamnestic MCI: ' num2str(numNamci) ' subjects'])
datetick('x', 12)
ylim([4 12])
xlim([intactdates(1) intactdates(end)]);

jun15 = datenum([2015 6 21 0 0 0]);
sept15 = datenum([2015 9 21 0 0 0]);
dec15 = datenum([2015 12 21 0 0 0]);
mar16 = datenum([2016 3 21 0 0 0]);
jun16 = datenum([2016 6 21 0 0 0]);

summer = jun15+1:sept15;
fall = sept15+1:dec15;
winter = dec15+1:mar16;
spring = mar16+1:jun16;

[~, summerIndices, ~] = intersect(intactdates, summer);
[~, fallIndices, ~] = intersect(intactdates, fall);
[~, winterIndices, ~] = intersect(intactdates, winter);
[~, springIndices, ~] = intersect(intactdates, spring);

summerAverage = mean(dailyAverageIntact(summerIndices));
fallAverage = mean(dailyAverageIntact(fallIndices));
winterAverage = mean(dailyAverageIntact(winterIndices));
springAverage = mean(dailyAverageIntact(springIndices));

sept = (datenum([2015 9 1 0 0 0]):datenum([2015 9 31 0 0 0]));
dec = (datenum([2015 12 1 0 0 0]):datenum([2015 12 31 0 0 0]));
march = (datenum([2016 3 1 0 0 0]):datenum([2016 3 3 0 0 0]));
july = (datenum([2016 7 1 0 0 0]):datenum([2016 7 31 0 0 0]));

[~, septIndices, ~] = intersect(intactdates, sept);
[~, decIndices, ~] = intersect(intactdates, dec);
[~, marchIndices, ~] = intersect(intactdates, march);
[~, julyIndices, ~] = intersect(intactdates, july);

septAverage = mean(dailyAverageIntact(septIndices));
decAverage = mean(dailyAverageIntact(decIndices));
marchAverage = mean(dailyAverageIntact(marchIndices));
julyAverage = mean(dailyAverageIntact(julyIndices));
%%%%%%%%%%%%%%%%%
[~, septIndices, ~] = intersect(amcidates, sept);
[~, decIndices, ~] = intersect(amcidates, dec);
[~, marchIndices, ~] = intersect(amcidates, march);
[~, julyIndices, ~] = intersect(amcidates, july);

septAverage = mean(dailyAverageAmci(septIndices));
decAverage = mean(dailyAverageAmci(decIndices));
marchAverage = mean(dailyAverageAmci(marchIndices));
julyAverage = mean(dailyAverageAmci(julyIndices));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, septIndices, ~] = intersect(namcidates, sept);
[~, decIndices, ~] = intersect(namcidates, dec);
[~, marchIndices, ~] = intersect(namcidates, march);
[~, julyIndices, ~] = intersect(namcidates, july);

septAverage = mean(dailyAverageNamci(septIndices))
decAverage = mean(dailyAverageNamci(decIndices))
marchAverage = mean(dailyAverageNamci(marchIndices))
julyAverage = mean(dailyAverageNamci(julyIndices))



MySQL.connect(Subjects.SERVER);
 intactTST = [];
 intactdate = [];
 namciTST = [];
 namcidate = [];
 amciTST = [];
 amcidate = [];
 numIntact = 0;
 numAmci = 0;
 numNamci = 0;
for n = 1 : length(oadc)
    % get total time asleep (TST) where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepTST ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 1 '];
    query = [query1 query2 query3 query4];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    del = find(qTST > 24 | qTST <= 0);
    qTST(del) = [];
    qdate(del) = [];
    if mci(n) == 0 
        intactTST = [intactTST qTST'];
        intactdate = [intactdate qdate'];
        numIntact = numIntact + 1;
    else
        if amci(n) == 1
            amciTST = [amciTST qTST'];
            amcidate = [amcidate qdate'];
            numAmci = numAmci + 1;
        else
            namciTST = [namciTST qTST'];
            namcidate = [namcidate qdate'];
            numNamci = numNamci + 1;
        end
    end
end

mysql('close')

intactdates = min(intactdate):max(intactdate);
dailyAverageIntact = [];

for d = min(intactdate):max(intactdate)
    thisday = find(intactdate == d);
    dailyAverageIntact = [dailyAverageIntact median(intactTST(thisday), 'omitnan')];
end
intactdates = intactdates(30:end);
dailyAverageIntact = dailyAverageIntact(30:end);

amcidates = min(amcidate):max(amcidate);
dailyAverageAmci = [];

for d = min(amcidate):max(amcidate)
    thisday = find(amcidate == d);
    dailyAverageAmci = [dailyAverageAmci median(amciTST(thisday), 'omitnan')];
end

namcidates = min(namcidate):max(namcidate);
dailyAverageNamci = [];

for d = min(namcidate):max(namcidate)
    thisday = find(namcidate == d);
    dailyAverageNamci = [dailyAverageNamci median(namciTST(thisday), 'omitnan')];
end

figure
subplot(3,1,1)
plot(intactdates, dailyAverageIntact,'.')
title(['Cognitively Intact: ' num2str(numIntact) ' subjects'])
datetick('x', 12)
ylim([4 12])
xlim([intactdates(1) intactdates(end)]);
hold on
p1 = -1.655e-23;
p2 = 1.922e-16;
p3 = -3.992e-10;
p4 = 0.0002657;
p5 = 17.25;
p6 = -8.114e7;
p7 = 2.27e13;
fit = p1*intactdates.^6 + p2*intactdates.^5 + p3*intactdates.^4 ...
    + p4*intactdates.^3 + p5*intactdates.^2 + p6*intactdates + p7;

plot(intactdates, fit, 'r')

subplot(3,1,2)
plot(amcidates, dailyAverageAmci,'.')
title(['Amnestic MCI: ' num2str(numAmci) ' subjects'])
datetick('x', 12)
ylim([4 12])
xlim([intactdates(1) intactdates(end)]);

subplot(3,1,3)
plot(namcidates, dailyAverageNamci, '.')
title(['Nonamnestic MCI: ' num2str(numNamci) ' subjects'])
datetick('x', 12)
ylim([4 12])
xlim([intactdates(1) intactdates(end)]);

jun15 = datenum([2015 6 21 0 0 0]);
sept15 = datenum([2015 9 21 0 0 0]);
dec15 = datenum([2015 12 21 0 0 0]);
mar16 = datenum([2016 3 21 0 0 0]);
jun16 = datenum([2016 6 21 0 0 0]);

summer = jun15+1:sept15;
fall = sept15+1:dec15;
winter = dec15+1:mar16;
spring = mar16+1:jun16;

[~, summerIndices, ~] = intersect(intactdates, summer);
[~, fallIndices, ~] = intersect(intactdates, fall);
[~, winterIndices, ~] = intersect(intactdates, winter);
[~, springIndices, ~] = intersect(intactdates, spring);

summerAverage = mean(dailyAverageIntact(summerIndices));
fallAverage = mean(dailyAverageIntact(fallIndices));
winterAverage = mean(dailyAverageIntact(winterIndices));
springAverage = mean(dailyAverageIntact(springIndices));

sept = (datenum([2015 9 1 0 0 0]):datenum([2015 9 31 0 0 0]));
dec = (datenum([2015 12 1 0 0 0]):datenum([2015 12 31 0 0 0]));
march = (datenum([2016 3 1 0 0 0]):datenum([2016 3 3 0 0 0]));
july = (datenum([2016 7 1 0 0 0]):datenum([2016 7 31 0 0 0]));

[~, septIndices, ~] = intersect(intactdates, sept);
[~, decIndices, ~] = intersect(intactdates, dec);
[~, marchIndices, ~] = intersect(intactdates, march);
[~, julyIndices, ~] = intersect(intactdates, july);

septAverage = mean(dailyAverageIntact(septIndices));
decAverage = mean(dailyAverageIntact(decIndices));
marchAverage = mean(dailyAverageIntact(marchIndices));
julyAverage = mean(dailyAverageIntact(julyIndices));
%%%%%%%%%%%%%%%%%
[~, septIndices, ~] = intersect(amcidates, sept);
[~, decIndices, ~] = intersect(amcidates, dec);
[~, marchIndices, ~] = intersect(amcidates, march);
[~, julyIndices, ~] = intersect(amcidates, july);

septAverage = mean(dailyAverageAmci(septIndices));
decAverage = mean(dailyAverageAmci(decIndices));
marchAverage = mean(dailyAverageAmci(marchIndices));
julyAverage = mean(dailyAverageAmci(julyIndices));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, septIndices, ~] = intersect(namcidates, sept);
[~, decIndices, ~] = intersect(namcidates, dec);
[~, marchIndices, ~] = intersect(namcidates, march);
[~, julyIndices, ~] = intersect(namcidates, july);

septAverage = mean(dailyAverageNamci(septIndices))
decAverage = mean(dailyAverageNamci(decIndices))
marchAverage = mean(dailyAverageNamci(marchIndices))
julyAverage = mean(dailyAverageNamci(julyIndices))