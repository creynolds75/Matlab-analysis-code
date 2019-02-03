rng 'default'
data1 = hour(WakeningTime);
data2 = hour(WakeningTime1);

edges = 0:1:23;
h1 = histcounts(data1,edges);
h2 = histcounts(data2,edges);

figure
bar(edges(1:end-1),[h1; h2]')

legend('1605', '1606')
title('Wake time')
ylabel('Number of nights')
xlabel('Hour of wake time')

ax = gca;
ax.XTick = ([0:2:22]);
ax.XTickLabel = ({'0:00', '2:00', '4:00', '6:00', '8:00', '10:00', ...
    '12:00', '14:00', '16:00', '18:00', '20:00', '22:00'})