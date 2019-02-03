for home = 1 : length(HomeID)
    home/length(HomeID)
    startdate = datenum(StartDate(home));
    enddate = datenum(EndDate(home));
    homeid = HomeID(home);
    [IS, IV, amplitude,L5, M10, RA, date] = calcISandIVforSensors(homeid, startdate, enddate)
    figure
    plot(date, RA)
    datetick('x')
    title(num2str(homeid))
end