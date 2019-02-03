clear all
load('couplesleep.mat')

dt1 = datetime(stampunix1, 'ConvertFrom', 'posixtime' );
dt1 = datetime(dt1, 'TimeZone', 'UTC');
dt1.TimeZone = 'local';

dt2 = datetime(stampunix2, 'ConvertFrom', 'posixtime' );
dt2 = datetime(dt2, 'TimeZone', 'UTC');
dt2.TimeZone = 'local';

startdate = datenum([2017 9 29 12 0 0]);
enddate = datenum([2017 10 3 12 0 0]);
i = find(datenum(dt1) > startdate & datenum(dt1) < enddate);
dt1 = dt1(i);
sleepstate1 = sleepstate1(i);

i = find(datenum(dt2) > startdate & datenum(dt2) < enddate);
dt2 = dt2(i);
sleepstate2 = sleepstate2(i);

