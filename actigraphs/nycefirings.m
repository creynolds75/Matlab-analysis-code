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

Stamp = Stamp + 7/24;

clear hours days
for n = 1 : length(Stamp)
    dv = datevec(Stamp(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3); 
end
del = find(days > 15 | days < 8);
hours(del) = [];
days(del) = [];

theta = -hours *2*pi/24+pi/2+7+pi;


figure
hold on
axis square
x = days.*cos(theta);
y = days.*sin(theta);
for n = 1 : length(x)
    plot(x(n), y(n),'b.', 'MarkerSize', 10)
end
 t = linspace(0, 2*pi, 100);
 plot(16*cos(t), 16*sin(t), 'k')
 plot(18*cos(t), 18*sin(t), 'k')
 for hr = 23:-1 : 0
    t = -hr*2*pi/24 + pi/2;
    
    text(17*cos(t)-0.5, 17*sin(t), num2str(hr))
 end
 day = unique(days);
for d = 1 : length(day)
    plot(day(d)*cos(linspace(0, 2*pi, 100)), day(d)*sin(linspace(0, 2*pi, 100)), 'k')
end
 o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

query1 = 'SELECT Stamp ';
query2 = 'FROM NYCEData.home_1353 ';
query3 = ['WHERE Event = 32 AND Sensor = ''000D6F000409133A'''];
query = [query1 query2 query3];
[Stamp] = mysql(query);
mysql('close')

Stamp = Stamp + 7/24;

clear hours days
for n = 1 : length(Stamp)
    dv = datevec(Stamp(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3); 
end
del = find(days > 15 | days < 8);
hours(del) = [];
days(del) = [];

theta = -hours *2*pi/24+pi/2+7+pi;

x = (days+0.5).*cos(theta);
y = (days+0.5).*sin(theta);
for n = 1 : length(x)
    plot(x(n), y(n),'g.', 'MarkerSize', 10)
end
