

function [IS, IV, amplitude,L5, M10, RA, date] = calcISandIVforSensors(homeid, startdate, enddate)

% Get all the sensor data from this home ID
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);
 
% keep only 32 firings - this gets rid of heartbeats and door openings
i = find(event == 32);
stamp = stamp(i);
IV = []; IS = []; date = []; amplitude = []; L5 = []; M10 = []; RA = [];
for day = startdate : 6 : enddate-6
    % Get a week's worth of data
    i = find(stamp > day & stamp < day + 6);
    week = stamp(i);
    
    %convert time stamps to hours
    stampsInHours = floor(week*24);
    %make a list of the unique hours
    uniqueHours = unique(stampsInHours);
    
    % go through the list of the unique hour, count up the number of firings
    % in each hour
    eventsPerHour = zeros(size(uniqueHours));
    for n = 1 : length(uniqueHours)
        i = find(stampsInHours == uniqueHours(n));
        eventsPerHour(n) = length(i);
    end

    % Find the hourly means - for each hour (such as 3:00 pm), average
    % together the counts for that hour for each day in the data set
    hourvalues = hour(uniqueHours/24);
    hourlymeans = zeros(1, 24);
    for n = 0 : 23
        i = find(hourvalues == n);
        hourlymeans(n+1) = mean(eventsPerHour(i));
    end
    % Replace any NaNs with zeros as these represent hours with no firings
    i = find(isnan(hourlymeans));
    hourlymeans(i) = 0;

    %% INTERDAILY STABILITY: degree of resemblance between activity patterns on
    % different days. A higher value indicates a more stable rhythm

    % n = total number of data
    n = length(eventsPerHour);
    % p = number of data per day (24)
    p = 24;
    xbar = mean(eventsPerHour);
    sum1 = 0;
    for i = 1 : p
        sum1 = sum1 + (hourlymeans(i) - xbar)^2;
    end
    sum2 = 0;
    for i = 1 : n
        sum2 = sum2 + (eventsPerHour(i) - xbar)^2;
    end
    weekIS = (n*sum1)/(p*sum2);

    % INTRADAILY VARIABILITY: degree of fragmentation of the rhythm - the
    % frequency of transitions between periods of rest and periods of activity

    sum1 = 0;
    for i = 2 : n
        sum1 = sum1 + (eventsPerHour(i) - eventsPerHour(i-1))^2;
    end
    sum2 = 0;
    for i = 1 : n
        sum2 = sum2 + (eventsPerHour(i) - xbar)^2;
    end

    weekIV = (n*sum1)/((n-1)*sum2);

    %% Amplitude
    weekamplitude = max(hourlymeans);
    
    %% L5: Least active 5 hours
    Nadir = 1;
    weekL5 = 1e6;

    for n = 1 : 20
        periodactivity = sum(hourlymeans(n:n+4));
        if periodactivity < weekL5
            weekL5 = periodactivity;
            Nadir = n;
        end
    end


    %% M10 is the sequence of the most active 10 hours 
    Peak = 1;
    weekM10 = 0;

    for n = 1 : 15
        periodactivity = sum(hourlymeans(n:n+9));
        if periodactivity > weekM10
            weekM10 = periodactivity;
            Peak = n;
        end
    end
    
    weekRA = (weekM10 - weekL5)/(weekM10 + weekL5);
    disp('NON-PARAMETRIC CIRCADIAN RHYTHM REPORT')
    disp(['IS: ' num2str(weekIS)])
    disp(['IV: ' num2str(weekIV)])
  
    IS = [IS weekIS];
    IV = [IV weekIV];
    date = [date day];
    amplitude = [amplitude weekamplitude];
    L5 = [L5 weekL5];
    M10 = [M10 weekM10];
    RA = [RA weekRA];
end

end