file = 
[dt, durations, sleepState, steps, subjectID] = loadActiviteData;


flooruniquedt = unique(floor(datenum(dt)));
floordt = floor(datenum(dt));

totalSleep = zeros(size(flooruniquedt));

for n = 1 : length(flooruniquedt)
    i = find(floordt == flooruniquedt(n));
    thisDaysSleep = sleepState(i);
    thisDaysDurations = durations(i);
    sleepIndices = find(thisDaysSleep > 0);
    totalSleep(n) = sum(thisDaysDurations(sleepIndices));
end

% get rid of NaNs in the date col
i = find(isnan(flooruniquedt));
flooruniquedt(i) = [];
totalSleep(i) = [];

% sort the data
[flooruniquedt, i] = sort(flooruniquedt);
totalSleep = totalSleep(i);

headers = {'Subject ID', 'Date', 'Total Sleep (secs)'};
filename = ['TotalSleep_' subjectID '.xlsx'];
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(totalSleep)
    row = {subjectID, datestr(flooruniquedt(n)), totalSleep(n)};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end
