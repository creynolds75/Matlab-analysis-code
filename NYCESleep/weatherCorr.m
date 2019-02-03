figure
subplot(3, 1, 1)
plot(weekIntactStarts, weeklyMedianIntactTST, '.-')
datetick('x', 12)

L = 45.5231;
%Feb 13 2015
day1 = 44;
% Nov 4 2016
day2 = 309 + 365;
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

[rho1, p] = corr(weeklyMedianIntactTST', night', 'Type', 'Spearman');

disp(['Intact rho btw TST and night length: ' num2str(rho1) ' p: ' num2str(p)])

subplot(3,1,3)
for n = 1 : length(weekIntactStarts)
    i = find(weatherdateNum > weekIntactStarts(n)-1 & weatherdateNum < weekIntactStarts(n)+1);
    
    if i > 0
    weeklyTemp(n) = (meanTemp(i)-32)/1.8;
    end
end

[rho2, p ] = corr(weeklyMedianIntactTST(1:length(weeklyTemp))', weeklyTemp', 'Type', 'Spearman');
disp(['Intact rho btw TST and temp: ' num2str(rho2) ' p: ' num2str(p)])
subplot(3,1,3)
plot(weeklyTemp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(3, 1, 1)
plot(weekAmciStarts, weeklyMedianAmciTST, '.-')
datetick('x', 12)

L = 45.5231;
%july 24 2015
day1 = 205;
% Nov 4 2016
day2 = 309 + 365;
days = linspace(day1, day2, length(weeklyMedianAmciTST));
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
plot(weekAmciStarts,night)

[rho1, p] = corr(weeklyMedianAmciTST', night', 'Type', 'Spearman');

disp(['aMCI rho btw TST and night length: ' num2str(rho1) ' p: ' num2str(p)])

subplot(3,1,3)
clear weeklyTemp
for n = 1 : length(weekAmciStarts)
    i = find(weatherdateNum > weekAmciStarts(n)-1 & weatherdateNum < weekAmciStarts(n)+1);
    
    if i > 0
    weeklyTemp(n) = (meanTemp(i)-32)/1.8;
    end
end

[rho2, p] = corr(weeklyMedianAmciTST(1:length(weeklyTemp))', weeklyTemp', 'Type', 'Spearman');
disp(['Amci rho btw TST and temp: ' num2str(rho2) ' p: ' num2str(p)])
subplot(3,1,3)
plot(weeklyTemp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555


figure
subplot(3, 1, 1)
plot(weekNamciStarts, weeklyMedianNamciTST, '.-')
datetick('x', 12)

L = 45.5231;
%july 24 2015
day1 = 205;
% Nov 4 2016
day2 = 309 + 365;
days = linspace(day1, day2, length(weeklyMedianNamciTST));
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
plot(weekNamciStarts,night)

[rho3, p] = corr(weeklyMedianNamciTST', night', 'Type', 'Spearman');

disp(['naMCI rho btw TST and night length: ' num2str(rho3) ' p: ' num2str(p)])

subplot(3,1,3)
clear weeklyTemp
for n = 1 : length(weekNamciStarts)
    i = find(weatherdateNum > weekNamciStarts(n)-1 & weatherdateNum < weekNamciStarts(n)+1);
    
    if i > 0
    weeklyTemp(n) = (meanTemp(i)-32)/1.8;
    end
end

[rho2, p] = corr(weeklyMedianNamciTST(1:length(weeklyTemp))', weeklyTemp', 'Type', 'Spearman');
disp(['Namci rho btw TST and temp: ' num2str(rho2) ' p: ' num2str(p)])
subplot(3,1,3)
plot(weeklyTemp)