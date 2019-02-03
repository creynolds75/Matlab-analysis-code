ChargeDateNum = datetime( chargeDates, 'ConvertFrom', 'posixtime' );

for n = 1 : length(ChargeDateNum)
    dv = datevec(ChargeDateNum(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3);
end

figure
hold on
for n = 1 : length(hours)
    if chargeSteps(n) > 0
      %  plot(hours(n), days(n),'ro', 'MarkerSize', chargeSteps(n)/10)
    end
end


 import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Stamp ';
query2 = 'FROM NYCEData.home_1353 ';
query3 = ['WHERE Event = 32 AND Sensor = ''000D6F0004B0EC47'''];
query = [query1 query2 query3];
[Stamp] = mysql(query);
mysql('close')

Stamp = Stamp - 7/24;

clear hours days
for n = 1 : length(Stamp)
    dv = datevec(Stamp(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3); 
end
del = find(days > 14 | days < 7);
hours(del) = [];
days(del) = [];

plot(hours, days, 'b.')
ylim([6 15])
xlim([0 24])
text(24, 7, 'Monday')
text(24, 8, 'Tuesday')
text(24, 9, 'Wednesday')
text(24, 10, 'Thursday')
text(24, 11, 'Friday')
text(24, 12, 'Saturday')
text(24, 13, 'Sunday')
text(24, 14, 'Monday')

ylabel('November')
xlabel('Hours')

set(gca,'Ydir','reverse')


o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Stamp ';
query2 = 'FROM NYCEData.home_1353 ';

query3 = ['WHERE Event = 32 AND Sensor = ''000D6F000409133A'''];
query = [query1 query2 query3];
[Stamp] = mysql(query);
mysql('close')

Stamp = Stamp - 7/24;

clear hours days
for n = 1 : length(Stamp)
    dv = datevec(Stamp(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3); 
end
del = find(days > 14 | days < 7);
hours(del) = [];
days(del) = [];

plot(hours, days, 'g.')