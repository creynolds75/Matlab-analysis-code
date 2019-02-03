mindate = floor(datenum([2016 7 19 0 0 0]));
maxdate = floor(today);
dates = (mindate:maxdate);
amplitudesum = zeros(size(dates));
numdates = zeros(size(dates));
for home = 1 : length(HomeID)
    home/length(HomeID)
    homeid = HomeID(home);
    startdate = datenum(StartDate(home));
    enddate = datenum(EndDate(home));
    [IS, IV, amplitude, date] = calcISandIVforSensors(homeid, mindate, maxdate);
    for d = 1 : length(dates)
        i = find(floor(date) == dates(d));
        if length(i) == 1
        amplitudesum(d) = amplitudesum(d) + amplitude(i);
        numdates(d) = numdates(d) + 1;
        end
    end
end

aveamplitude = amplitudesum ./ numdates;

