today = datenum([2017 5 17 0 0 0]);

% AWBedDatenums = datenum(AWBedDate) + datenum(AWBedTime) - today;
% AWWakeDatenums = datenum(AWWakeDate) + datenum(AWWakeTime) - today;
% 
% NYCEBedDatenums = datenum(NYCEBedDate) + datenum(NYCEBedTime) - today;
% NYCEWakeDatenums = datenum(NYCEWakeDate) + datenum(NYCEWakeTime) - today;

AWBedDatenums = datenum(AWBedTime);
AWWakeDatenums = datenum(AWWakeTime);
% 
NYCEBedDatenums = datenum(NYCEBedTime);
NYCEWakeDatenums = datenum(NYCEWakeTime);

figure
startbed = datenum([2017 5 17 21 0 0]);
endbed = datenum([2017 5 17 23 59 59]);
plot(AWBedDatenums, NYCEBedDatenums, '.')
xlabel('Actiwatch Bed Times')
ylabel('NYCE Bed Times')
startbed = datenum([2017 5 17 21 0 0]);
endbed = datenum([2017 5 17 23 59 59]);
xlim([startbed endbed]);
ylim([startbed endbed])
datetick('x')
datetick('y')
title('Comparing Bed Times for Actiwatch and NYCE')

figure
plot(AWWakeDatenums, NYCEWakeDatenums, '.')
xlabel('Actiwatch Bed Times')
ylabel('NYCE Bed Times')
startwake = datenum([5 17 2017 5 0 0 ]);
endwake = datenum([5 17 2017 10 0 0]);
ylim([startwake endwake])
xlim([startwake endwake])
datetick('x')
datetick('y')
title('Comparing Wakening Times for Actiwatch and NYCE')

figure
plot(AWTST, NYCETST, '.')
xlabel('Actiwatch Total Sleep Time (min)')
ylabel('NYCE Total Sleep Time (min)')
title('Comparing Total Sleep Time for Actiwatch and NYCE')




