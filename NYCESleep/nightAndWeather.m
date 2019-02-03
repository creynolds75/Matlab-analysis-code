for n= 2 : length(PDT)
    split = strsplit(PDT{n}, '-');
    weatherdates(n-1) = datenum([str2double(split{1}) str2double(split{2}) str2double(split{3}) 0 0 0]);
end
figure
plot(weatherdates, MeanTemperatureF)
datetick('x', 12)

for n = 1 : length(weekIntactStarts)
    i = find(weatherdates > weekIntactStarts(n)-1 & weatherdates < weekIntactStarts(n)+1);
    weeklyTemp(n) = MeanTemperatureF(i);
end

figure
subplot(2,1,1)
plot(weekIntactStarts, weeklyMedianIntactTST, '.-')
title('Total sleep time - intact')
subplot(2,1,2)
plot(weekIntactStarts, weeklyTemp, '.-')
datetick('x', 12)

%%%%%%%%%%%%%%%%%%%
for n = 1 : length(weekNamciStarts)
    i = find(weatherdates > weekNamciStarts(n)-1 & weatherdates < weekNamciStarts(n)+1);
    weeklyNamciTemp(n) = MeanTemperatureF(i);
end

figure
subplot(2,1,1)
plot(weekNamciStarts, weeklyMedianNamciTST, '.-')
title('Total sleep time - namci')
subplot(2,1,2)
plot(weekNamciStarts, weeklyNamciTemp, '.-')
datetick('x', 12)