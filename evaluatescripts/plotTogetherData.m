
labels = {'Oct 17', 'Nov 17', 'Dec 17', 'Jan 18', 'Feb 18', 'Mar 18', 'Apr 18', 'May 18'};

figure

subplot(2,2,1)
bar(kitchenmonthsum)
ylim([0 2000])

set(gca, 'FontSize', 8)
set(gca, 'xticklabel', labels)

title('Kitchen')
ylabel('Minutes')

subplot(2,2,2)
bar(bedroommonthsum)
ylim([0 2000])
set(gca, 'FontSize', 8)
set(gca, 'xticklabel', labels)

title('Bedroom')
ylabel('Minutes')

subplot(2,2,3)
bar(bathroommonthsum)
ylim([0 2000])
set(gca, 'FontSize', 8)
set(gca, 'xticklabel', labels)

title('Bathroom')
ylabel('Minutes')

subplot(2,2,4)
bar(livingmonthsum)
ylim([0 2000])
set(gca, 'FontSize', 8)
set(gca, 'xticklabel', labels)

title('Living Room')
ylabel('Minutes')