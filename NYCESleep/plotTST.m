figure

subplot(3, 1, 1)
plot(weekIntactStarts, weeklyMedianIntactTST, '.-')
title('Total Sleep Time for Cognitively Intact Group')
datetick('x', 12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylabel('Hours')
ylim([6 10])


subplot(3, 1, 2)
plot(weekAmciStarts, weeklyMedianAmciTST, '.-')
title('Total Sleep Time for Amnestic MCI Group')
datetick('x', 12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylabel('Hours')
ylim([6 10])

subplot(3, 1, 3)
plot(weekNamciStarts, weeklyMedianNamciTST, '.-')
title('Total Sleep Time for Non-amnestic MCI Group')
datetick('x', 12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylabel('Hours')
ylim([6 10])

figure
subplot(3, 1, 1)
plot(weekIntactStarts, weeklyMedianIntactTST, '.-')
title('Total Sleep Time for Cognitively Intact Group')
datetick('x', 12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylabel('Hours')
ylim([min(weeklyMedianIntactTST) max(weeklyMedianIntactTST)])

L = 45.5231;
%Feb 13 2015
day1 = 44;
% Nov 11 2016
day2 = 316 + 365;
days = linspace(day1, day2, length(weeklyMedianIntactTST));
clear D
for n=1:length(days)
    J = days(n);
    %CBM Model
    theta=0.2163108+2*atan(0.9671396*tan(0.00860*(J-186))); %revolution angle from day of the year
    P = asin(0.39795*cos(theta)); %sun declination angle 
    %daylength (plus twilight)- 
    p=0.8333; %sunrise/sunset is when the top of the sun is apparently even with horizon
    D(n) = 24 - (24/pi) * acos((sin(p*pi/180)+sin(L*pi/180)*sin(P))/(cos(L*pi/180)*cos(P))); 
end
night = 24-D;
subplot(3,1,2)
plot(weekIntactStarts,night)
datetick('x', 12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylabel('Hours')
title('Length of Night')

subplot(3,1,3)
weatherDates = linspace(weekIntactStarts(1), weekIntactStarts(end), length(tempC));
plot(weatherDates, tempC)
datetick('x', 12)
xlim([weekIntactStarts(1) weekIntactStarts(end)])
ylabel('Degrees Celsius')
title('Mean Outdoor Temperature')


for n = 1 : length(weekIntactStarts)
    i = find(weatherDates > weekIntactStarts(n)-1 & weatherDates < weekIntactStarts(n)+1);
    
    if i > 0
        weeklyTemp(n) = tempC(i);
    end
end