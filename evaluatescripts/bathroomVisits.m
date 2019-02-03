import Orcatech.Flags.Areas
import Orcatech.Algorithms.Sleep

% Get the flags for the bathroom 
bathids = Areas.getIds(Sleep.AREA_FLAGS_BATHROOMS);

% Loop through the home IDs
HomeIDs = [1394, 1395, 1400, 1402, 1404, 1407, 1405, 1412, 1414, 1421,1428];
startdate = datenum([2017 4 1 0 0 0]);
enddate = datenum([2018 1 31 0 0 0]);

for n = 1 : length(HomeIDs)
    HomeID = HomeIDs(n);
    
    % Get sensor firings for this home ID between the given dates
    [stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(HomeID, startdate, enddate);

    % Find all the bathroom firings where areaid is one of the bathroom ids and
    % the event type is 32
    % First get all the 32 firings
    event32 = find(event==32);
    stamp32 = stamp(event32);
    areaid_nyce32 = areaid_nyce(event32);
    % Next, get the time stamps of the bathroom firings
    bathroomFiringIndices = find(ismember(areaid_nyce32, bathids) == 1);
    bathroomTimeStamps = stamp32(bathroomFiringIndices);
    % Now get the time stamps for the rest of the house 
    nonbathroomFiringIndices = find(ismember(areaid_nyce32, bathids) == 0);
    nonbathroomTimeStamps = stamp32(nonbathroomFiringIndices);
    
    % find the gaps between the bathroom firings
    gaps = diff(bathroomTimeStamps);
    % convert gaps to minutes from days
    gaps = gaps * 24*60;
    % find gaps greater than 10 minutes
    gapsGreaterThan10 = find(gaps > 20);
    
    % find the indices of bathroom firings that represent the start and end of
    % a visit to the bathroom
    startVisit = gapsGreaterThan10 + 1;
    % add the first firing to this list
    startVisit = [1 startVisit'];
    endVisit = gapsGreaterThan10;
    % add the last firing to this list
    endVisit = [endVisit' length(bathroomTimeStamps)];
    
    beginningday = floor(stamp(1));
    endday = floor(stamp(end));
    numberofdays = endday - beginningday;
    
    % Now check for firings in other rooms

    timeTogetherInBathroom = zeros(numberofdays+1,1);
    dates = zeros(numberofdays+1,1);
    previousdate = 0;
    d = 0;
    for n = 1 : length(startVisit)
        s = bathroomTimeStamps(startVisit(n));
        e = bathroomTimeStamps(endVisit(n));
        if previousdate ~= floor(s)
            d = d + 1;
        end
        previousdate = floor(s);
        nonbathroom = find(nonbathroomTimeStamps > s & nonbathroomTimeStamps < e);
        if length(nonbathroom) == 0
            timeTogetherInBathroom(d) = timeTogetherInBathroom(d) + (e-s)*24*60;
        end
    end
    % figure out how many bathroom visits per day
    visitsToBathroom = zeros(numberofdays+1,1);
    previousdate = 0;
    d = 0;
    for n = 1 : length(startVisit)
        s = bathroomTimeStamps(startVisit(n));
        if previousdate ~= floor(s)
            d = d + 1;
        end
        previousdate = floor(s);
        visitsToBathroom(d) = visitsToBathroom(d) + 1;
        dates(d) = s;
    end
    headers = {'Date', 'Total Trips to Bathroom', 'Time Together in Bathroom (min)'};
    filename = ['BathroomData_HomeID' num2str(HomeID) '.xlsx'];
    xlswrite(filename, headers);
    rownum = 2;

    for n = 1 : length(timeTogetherInBathroom)
        if timeTogetherInBathroom(n) > 0 && visitsToBathroom(n) > 0
            row = {datestr(dates(n)), visitsToBathroom(n), timeTogetherInBathroom(n)};
            xlswrite(filename, row, 1, ['A' num2str(rownum)]);
            rownum = rownum + 1;
        end
    end
end