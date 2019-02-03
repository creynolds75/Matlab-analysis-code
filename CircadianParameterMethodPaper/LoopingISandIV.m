[dt, ~, ~, steps, subjectID] = loadActiviteData;

% Convert date times to datenums
datenums = datenum(dt);

% Get rid of any NaNs
del = find(isnan(datenums));
datenums(del) = [];
dt(del) = [];
steps(del) = [];

% Loop through the data in weekly bins
% Subtract 7 from end to make sure we have enough data
% to have full weeks

uniquedays = unique(floor(datenums));
IS = [];
IV = [];
date = [];
for n = 1 : 6 : length(uniquedays) - 6
    start = uniquedays(n);
    date = [date start];
    stop = uniquedays(n+6);
    i = find(datenums > start & datenums < stop);
    weekSteps = steps(i);
    weekdt = dt(i);
    weekdatenums = datenums(i);
    
    % convert the date num for each walk value into hours
    datenumhours = floor(weekdatenums*24);
    % find all the unique hours represented in the data
    uniquehours = unique(datenumhours);
    % loop through the hours and sum all the steps for each hour
    hourlysums = zeros(size(uniquehours));
    for n = 1 : length(uniquehours)
        i = find(datenumhours == uniquehours(n));
        hourlysums(n) = sum(weekSteps(i));
    end
    
    % Find the hourly means
    dv = datevec(uniquehours/24);
    %%% FIX HERE %%%
    hourvalues = dv(:,4);
    hourlymeans = zeros(1, 24);
    for n = 0 : 23
        i = find(hourvalues == n);
        hourlymeans(n+1) = mean(hourlysums(i), 'omitnan');
    end
    
    %% INTERDAILY STABILITY: degree of resemblance between activity patterns on
    % different days. A higher value indicates a more stable rhythm

    % n = total number of data
    n = length(hourlysums);
    % p = number of data per day (24)
    p = 24;
    xbar = mean(hourlysums, 'omitnan');
    sum1 = 0;
    for i = 1 : p
        sum1 = sum1 + (hourlymeans(i) - xbar)^2;
    end
    sum2 = 0;
    for i = 1 : n
        sum2 = sum2 + (hourlysums(i) - xbar)^2;
    end
    IS = [IS (n*sum1)/(p*sum2)];

    %% INTRADAILY VARIABILITY: degree of fragmentation of the rhythm - the
   % frequency of transitions between periods of rest and periods of activity

    sum1 = 0;
    for i = 2 : n
        sum1 = sum1 + (hourlysums(i) - hourlysums(i-1))^2;
    end
    sum2 = 0;
    for i = 1 : n
        sum2 = sum2 + (hourlysums(i) - xbar)^2;
    end

    IV = [IV (n*sum1)/((n-1)*sum2)];
    
    disp('NON-PARAMETRIC CIRCADIAN RHYTHM REPORT')
    disp(['IS: ' num2str(IS)])
    %disp(['IV: ' num2str(IV)])

end