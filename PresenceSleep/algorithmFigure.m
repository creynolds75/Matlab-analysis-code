figure
hold on

plot(bedroomStamps, 10*ones(size(bedroomStamps)), 'r.')
plot(livingroomStamps, 15 *ones(size(livingroomStamps)), 'g.')
plot(bathroomStamps, 20*ones(size(bathroomStamps)), 'b.')
plot(kitchenStamps, 25*ones(size(kitchenStamps)), 'c.')
plot(frontdoorStamps, 30*ones(size(frontdoorStamps)), 'k.')
ylim([5 30])
datetick('x')

figure 
hold on
plot(bedroomStamps, 10*ones(size(bedroomStamps)), 'r.')
% Find all the 32 firings - 32 = presence detected
presenceDetectedIndices = find(bedroomEvents == 32);

% Find the time stamps for these detections
presenceDetectedTimeStamps = bedroomStamps(presenceDetectedIndices);
plot(presenceDetectedTimeStamps, 10*ones(size(presenceDetectedIndices)), 'ro')
ylim([5 15])
datetick('x')

figure
% Find time stamps between 6 pm and noon - this will need to be generalized 
nighttimeIndices = find(presenceDetectedTimeStamps > sixpm ...
    & presenceDetectedTimeStamps < noon);
nighttimeTimeStamps = presenceDetectedTimeStamps(nighttimeIndices);
plot(nighttimeTimeStamps, 10*ones(size(nighttimeTimeStamps)), 'r.')
datetick('x')
ylim([9 11])

figure
hold on
plot(hoursSince6pm(2:end), timeDiffBetweenFirings*60, '.', 'MarkerSize', 14)
i = find(timeDiffBetweenFirings > 5/60);
plot(hoursSince6pm(i+1), timeDiffBetweenFirings(i)*60, 'o', 'MarkerSize', 14)
xlabel('Hours since 6 pm')
ylabel('Minutes')
title('Time Difference Between Firings')
