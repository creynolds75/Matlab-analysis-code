dt = datetime( stampunix, 'ConvertFrom', 'posixtime' );
dt = datetime(dt, 'TimeZone', 'UTC');
dt.TimeZone = 'local';

% Get the data from the month of October
startdate = datenum([2017 10 01 00 00 00]);
enddate = datenum([2017 10 31 23 59 59]);close 
i = find(datenum(dt) > startdate & datenum(dt) < enddate);
dt = dt(i);
sleep = sleep(i);
figure
hold on
sept30 = datenum([2017 9 30 0 0 0]);
step = 2*pi/(24*60);
for n = 1 : length(sleep)
    r = floor(datenum(dt(n)) - sept30);
    theta = -(datenum(dt(n)) - datenum(dt(1)))*2*pi +pi/2;
    if sleep(n) > 0
        plot(linspace(r*cos(theta), r*cos(theta+step), 5), linspace(r*sin(theta), r*sin(theta+step),5), 'k', 'LineWidth', 4)
    end
end