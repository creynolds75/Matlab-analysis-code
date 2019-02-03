dates = datenum(datetime(VarName1, 'ConvertFrom', 'posixtime'));

for n = 1 : length(dates)
    dv = datevec(dates(n));
    hours(n) = dv(4)+dv(5)/60+dv(6)/3600;
    days(n) = dv(3); 
end

days = days - days(1)+5;

figure
theta = -hours *2*pi/24+pi/2;
hold on
axis square
x = days.*cos(theta);
y = days.*sin(theta);
for n = 1 : length(x)
    
    if VarName2(n) > 0
        c = VarName2(n)/max(VarName2);
        %plot(x(n), y(n),'.','Color',[1,c,c], 'MarkerSize', 22)
        plot(x(n), y(n),'ro','MarkerSize', VarName2(n)/10)
    end
end
 t = linspace(0, 2*pi, 100);
 plot(13*cos(t), 13*sin(t), 'k')
 plot(15*cos(t), 15*sin(t), 'k')
 for hr = 23:-1 : 0
    t = -hr*2*pi/24 + pi/2;
    
    text(14*cos(t)-0.5, 14*sin(t), num2str(hr))
 end
ax = gca;
ax.YTick = [];
ax.XTick = [];