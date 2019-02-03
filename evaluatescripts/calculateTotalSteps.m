[dt, durations, sleepState, steps, subjectID] = loadActiviteData;

flooruniquedt = unique(floor(datenum(dt)));
floordt = floor(datenum(dt));

totalsteps = zeros(size(flooruniquedt));

for n = 1 : length(flooruniquedt)
    i = find(floordt == flooruniquedt(n));
    totalsteps(n) = sum(steps(i));
end

% get rid of NaNs in the date col
i = find(isnan(flooruniquedt));
flooruniquedt(i) = [];
totalsteps(i) = [];

% sort the data
[flooruniquedt, i] = sort(flooruniquedt);
totalsteps = totalsteps(i);

headers = {'Date', 'Total Steps'};
filename = ['TotalSteps_' subjectID '.xlsx'];
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(totalsteps)
    row = {datestr(flooruniquedt(n)), totalsteps(n)};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end


