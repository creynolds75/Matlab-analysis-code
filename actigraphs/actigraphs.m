figure 
hold on

withDate = datenum(datetime(withUnixDate, 'ConvertFrom', 'posixtime'));

d1 = datenum([2016 10 04 0 0 0]);
d2 = datenum([2016 10 11 0 0 0]);
sectionIndices = find(withDate > d1 & withDate < d2);
figure
subplot(4,1,1)
withingsAct(withingsAct > 1000) = NaN;
plot(withDate(sectionIndices), withingsAct(sectionIndices))
datetick('x')
title('Withings')



chargeDate = datenum(datetime(chargeUnixTime, 'ConvertFrom', 'posixtime'));

d1 = datenum([2016 10 04 0 0 0]);
d2 = datenum([2016 10 11 0 0 0]);
sectionIndices = find(chargeDate > d1 & chargeDate < d2);

subplot(4,1,2)
plot(chargeDate(sectionIndices), chargeAct(sectionIndices))
datetick('x')
title('Fitbit Charge')

flexDate = datenum(datetime(flexUnixTime, 'ConvertFrom', 'posixtime'));

d1 = datenum([2016 10 04 0 0 0]);
d2 = datenum([2016 10 11 0 0 0]);
sectionIndices = find(flexDate > d1 & flexDate < d2);

subplot(4,1,3)
plot(flexDate(sectionIndices), flexAct(sectionIndices))
datetick('x')
title('Fitbit Flex')


% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Stamp ';
query2 = 'FROM NYCEData.home_1353 ';
query3 = ['WHERE Event = 32 AND Sensor = ''000D6F000409133A'''];
query = [query1 query2 query3];
[Stamp] = mysql(query);
Stamp = Stamp + 7/24;


datestr1 = datenum([2016 10 04 0 0 0]);
datestr2 = datenum([2016 10 11 0 0 0]);

del = find(Stamp < datestr1 | Stamp > datestr2);
Stamp(del) = [];
events = ones(size(Stamp));
subplot(4,1,4)
hold on
plot(Stamp, events, 'o')
datetick('x')
title('Apartment Sensor Firings')

query1 = 'SELECT Stamp ';
query2 = 'FROM NYCEData.home_1353 ';
query3 = ['WHERE Event = 32 AND Sensor = ''000D6F0004B0EC47'''];
query = [query1 query2 query3];
[Stamp] = mysql(query);
Stamp = Stamp + 7/24;
mysql('close')

datestr1 = datenum([2016 10 04 0 0 0]);
datestr2 = datenum([2016 10 11 0 0 0]);

del = find(Stamp < datestr1 | Stamp > datestr2);
Stamp(del) = [];
events = ones(size(Stamp));
subplot(4,1,4)
plot(Stamp, events, 'ro')
datetick('x')
title('Apartment Sensor Firings')

mysql('close')