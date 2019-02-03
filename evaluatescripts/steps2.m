dt = datetime( stampunix, 'ConvertFrom', 'posixtime' );

nonzerosteps = steps(find(steps > 0));
nonzerodt = dt(find(steps > 0));

% subject ID 1526 Home ID 1400
startdate = datenum([2017 09 03 0 0 0]);
enddate = datenum([2017 10 10 0 0 0]);
homeid = 1394;
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);

doorsensorid = 56;

% find all the door sensor firings
doorfiringstamps = stamp(find(areaid_nyce == doorsensorid));
doorfiringevents = event(find(areaid_nyce == doorsensorid));

figure
hold on
%plot(nonzerodt, nonzerosteps, '.')
for n = 1 : length(doorfiringstamps)
    plot([doorfiringstamps(n) doorfiringstamps(n)], [0 140], 'k')
end


