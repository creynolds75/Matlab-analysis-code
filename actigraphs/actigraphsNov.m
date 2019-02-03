ChargeDateNum = datetime( ChargeDates, 'ConvertFrom', 'posixtime' );
FlexDateNum = datetime( FlexDates, 'ConvertFrom', 'posixtime' );

figure
plot(ChargeDateNum, ChargeSteps)
title('Charge')
datetick('x')

figure
plot(FlexDateNum, FlexSteps)
title('Flex')
datetick('x')

overlap1 = datenum([2016 11 07 0 0 0]);
overlap2 = datenum([2016 11 11 0 0 0]);
% 
chargeKeep = find(datenum(ChargeDateNum) >= overlap1 & datenum(ChargeDateNum) <= overlap2);
flexKeep = find(datenum(FlexDateNum) >= overlap1 & datenum(FlexDateNum) <= overlap2);

figure
hold on
plot(ChargeDateNum(chargeKeep), ChargeSteps(chargeKeep), '.')

datetick('x')
title('Overlap')
plot(FlexDateNum(flexKeep), FlexSteps(flexKeep), '.') 
legend('Charge', 'Flex')

figure
plot(FlexDateNum(flexKeep), ChargeSteps(chargeKeep)-FlexSteps(flexKeep))
title('Charge - Flex')
datetick('x')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1 : length(ChargeDateNum)
    dv = datevec(ChargeDateNum(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3); 
end
steps = ChargeSteps;
del = find(days > 15 | days < 8);
hours(del) = [];
days(del) = [];
steps(del) = [];
figure
hold on
theta = -hours *2*pi/24 +pi/2;
hold on
axis square
x = days.*cos(theta);
y = days.*sin(theta);
%plot(x, y)
day = unique(days);
for d = 1 : length(day)
    plot(day(d)*cos(linspace(0, 2*pi, 100)), day(d)*sin(linspace(0, 2*pi, 100)), 'k')
end
hold on
for n = 1 : length(x)
    if steps(n) > 0
        plot(x(n), y(n),'ro','MarkerSize', steps(n)/10)
    end
end

 t = linspace(0, 2*pi, 100);
 plot(15*cos(t), 15*sin(t), 'k')
 plot(17*cos(t), 17*sin(t), 'k')
 for hr = 23:-1 : 0
    t = -hr*2*pi/24 + pi/2;
    
    text(16*cos(t)-0.5, 16*sin(t), num2str(hr))
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
hold on
theta = -hours *2*pi/24+pi/2+7+pi;
hold on
axis square

x = days.*cos(theta);
y = days.*sin(theta);
for n = 1 : length(x)
  %  plot(x(n), y(n),'b.', 'MarkerSize', 10)
end
