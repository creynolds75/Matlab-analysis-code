% Loop through the sensor activity

for n = 1 : length(HomeID)
    homeid = HomeID(n);
    startdate = datenum(StartDate(n));
    enddate = datenum(EndDate(n));
    [IS, IV, date] = calcISandIVforSensors(homeid, startdate, enddate);
    figure
    title(num2str(homeid))
    subplot(2, 1, 1)
    plot(date, IS)
    subplot(2, 1, 2)
    plot(date, IV)
end
