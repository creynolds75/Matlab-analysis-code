withAct(withAct > 1000) = 1000;

for n = 1 : length(withDate)
    dv = datevec(withDate(n));
    withhours(n) = dv(4)+dv(5)/60+dv(6)/3600-7;
    withdays(n) = dv(3); 
end

withtheta = withhours *2*pi/24;
figure
hold on
x = withdays.*cos(withtheta);
y = withdays.*sin(withtheta);
for n = 1 : length(x)
plot(x(n), y(n), 'ro', 'MarkerSize', withAct(n)/100)
end
hold on



axis square
ax = gca;
ax.YTick = [];
ax.XTick = [];

flexDate = datenum(datetime(flexUnixTime, 'ConvertFrom', 'posixtime'));

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
plot(x(n), y(n), 'go', 'MarkerSize', flexAct(n)/10)
    end
end




chargeDate = datenum(datetime(chargeUnixTime, 'ConvertFrom', 'posixtime'));

for n = 1 : length(chargeDate)
    dv = datevec(chargeDate(n));
    chargehours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    chargedays(n) = dv(3); 
end

chargetheta = chargehours *2*pi/24;

x = chargedays.*cos(chargetheta);
y = chargedays.*sin(chargetheta);
for n = 1 : length(x)
    if chargeAct(n) > 0
plot(x(n), y(n), 'bo', 'MarkerSize', chargeAct(n)/10)
    end
end