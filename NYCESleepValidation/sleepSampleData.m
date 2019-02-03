bedSpark(1) = datenum([2017 10 12 10 48 00]);
bedSpark(2) = datenum([2017 10 12 10 59 00]);
bedSpark(3) = datenum([2017 10 12 9 37 50]);
bedSpark(4) = datenum([2017 10 12 10 22 17]);
bedSpark(5) = datenum([2017 10 12 10 49 48]);
bedSpark(6) = datenum([2017 10 12 10 21 58]);

bedActiwatch(1) = datenum([2017 10 12 10 52 00]);
bedActiwatch(2) = datenum([2017 10 12 11 04 00]);
bedActiwatch(3) = datenum([2017 10 12 9 40 00]);
bedActiwatch(4) = datenum([2017 10 12 10 22 00]);
bedActiwatch(5) = datenum([2017 10 12 10 54 00]);
bedActiwatch(6) = datenum([2017 10 12 10 24 00]);

wakeSpark(1) = datenum([2017 10 12 7 24 00]);
wakeSpark(2) = datenum([2017 10 12 5 08 00]);
wakeSpark(3) = datenum([2017 10 12 6 51 00]);
wakeSpark(4) = datenum([2017 10 12 7 24 00]);
wakeSpark(5) = datenum([2017 10 12 7 19 00]);
wakeSpark(6) = datenum([2017 10 12 7 00 00]);

wakeActiwatch(1) = datenum([2017 10 12 7 04 00]);
wakeActiwatch(2) = datenum([2017 10 12 5 08 00]);
wakeActiwatch(3) = datenum([2017 10 12 6 51 00]);
wakeActiwatch(4) = datenum([2017 10 12 7 24 00]);
wakeActiwatch(5) = datenum([2017 10 12 7 19 00]);
wakeActiwatch(6) = datenum([2017 10 12 7 00 00]);

figure
plot(bedSpark, bedActiwatch, '.')
datetick('x')
datetick('y')

figure
plot(wakeSpark, wakeActiwatch, '.')
datetick('x')
datetick('y')
