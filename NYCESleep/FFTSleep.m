offsetDates = intactdates - intactdates(1);
meanSleep = mean(dailyAverageIntact);
offsetSleep = dailyAverageIntact - meanSleep;
figure
plot(offsetDates, offsetSleep, '.')

monthaverage = [];
for n = 1 : 30 : length(offsetDates) - 30
    monthaverage = [monthaverage mean(offsetSleep(n:n+29))];
end


figure
plot(monthaverage)



