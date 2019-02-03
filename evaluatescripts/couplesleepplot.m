figure
subplot(2,1,1)
sleepstate1(sleepstate1 > 0) = 1;
plot(dt1, sleepstate1, '.-')
datetick('x')
ylim([-0.5 1.5])
set(gca,'YTickLabel',[]);

subplot(2,1,2)
sleepstate2(sleepstate2 > 0) = 1;
plot(dt2, sleepstate2, '.-')
datetick('x')
ylim([-0.5 1.5])
set(gca,'YTickLabel',[]);