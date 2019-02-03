[dt, durations, sleepState, steps, subjectID] = loadActiviteData;

% limit to between 8 pm and 9 am
[~,~,~,h, m, s] = datevec(dt);
i = find(h >= 20 & h <= 23);
j = find(h >=0 & h <= 9);
keep = [i' j'];

dt = dt(keep);
durations = durations(keep);
sleepState = sleepState(keep);

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



% headers = {'Subject ID', 'Date', 'Total Sleep (secs)'};
% filename = ['TotalSleep_' subjectID '.xlsx'];
% xlswrite(filename, headers);
% rownum = 2;
% 
% for n = 1 : length(totalSleep)
%     row = {subjectID, datestr(flooruniquedt(n)), totalSleep(n)};
%     xlswrite(filename, row, 1, ['A' num2str(rownum)]);
%     rownum = rownum + 1;
% end
