fitbittime = VarName1;
fitbitcounts = VarName2;

% get the date correct
dvs = datevec(fitbittime);
dvs(:,1) = 2016;
dvs(:,2) = 9;
dvs(:,3) = 28;
% convert to local time
dvs(:,4) = dvs(:,4) + 7;
dates = datenum(dvs);
figure
subplot(2, 1, 1)
plot(dates, fitbitcounts)
datetick('x')
title('Fitbit data for Sept 28, 2016')

% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Stamp ';
query2 = 'FROM NYCEData.home_1353 ';
query3 = ['WHERE Event = 32'];
query = [query1 query2 query3];
[Stamp] = mysql(query);
Stamp = Stamp + 7/24;
mysql('close')

datestr1 = datenum([2016 9 28 0 0 0]);
datestr2 = datenum([2016 9 28 23 59 59]);

del = find(Stamp < datestr1 | Stamp > datestr2);
Stamp(del) = [];
subplot(2,1,2)

events = ones(size(Stamp));
plot(Stamp, events, 'o')
datetick('x')
title('Apartment Sensor Firings')