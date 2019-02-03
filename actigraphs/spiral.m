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

for n = 1 : length(Stamp)
    dv = datevec(Stamp(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600-7;
    days(n) = dv(3); 
end

theta = hours *2*pi/24;
figure
x = days.*cos(theta);
y = days.*sin(theta);
plot(x, y, '.')
hold on

withDate = datenum(datetime(withingsUnixTime, 'ConvertFrom', 'posixtime'));

d1 = datenum([2016 10 04 0 0 0]);
d2 = datenum([2016 10 11 0 0 0]);
sectionIndices = find(withDate > d1 & withDate < d2);



withDate = withDate(sectionIndices);
withingsAct = origwithingsact(sectionIndices);
withingsAct(withingsAct > 1000) = 1000;

for n = 1 : length(withDate)
    dv = datevec(withDate(n));
    withhours(n) = dv(4)+dv(5)/60+dv(6)/3600-7;
    withdays(n) = dv(3); 
end

withtheta = withhours *2*pi/24;

x = withdays.*cos(withtheta);
y = withdays.*sin(withtheta);
for n = 1 : length(x)
plot(x(n), y(n), 'ro', 'MarkerSize', withingsAct(n)/100)
end
hold on


 t = linspace(0, 2*pi, 100);
 plot(11*cos(t), 11*sin(t), 'k')
 plot(13*cos(t), 13*sin(t), 'k')

for hr = 0 : 23
    t = hr*2*pi/24;
    
    text(12*cos(t)-0.5, 12*sin(t), num2str(hr))
end
axis square
ax = gca;
ax.YTick = [];
ax.XTick = [];

text(4-1, 0, 'Oct 4')
text(10-1, 0, 'Oct 10')
text(7-1, 0, 'Oct 7')




flexDate = datenum(datetime(flexUnixTime, 'ConvertFrom', 'posixtime'));

d1 = datenum([2016 10 04 0 0 0]);
d2 = datenum([2016 10 11 0 0 0]);
sectionIndices = find(flexDate > d1 & flexDate < d2);

flexDate = flexDate(sectionIndices);
flexAct = flexAct(sectionIndices);

for n = 1 : length(flexDate)
    dv = datevec(flexDate(n));
    flexhours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    flexdays(n) = dv(3); 
end

flextheta = flexhours *2*pi/24;

x = flexdays.*cos(flextheta);
y = flexdays.*sin(flextheta);
for n = 1 : length(x)
    if flexAct(n) > 0
%plot(x(n), y(n), 'go', 'MarkerSize', flexAct(n)/10)
    end
end