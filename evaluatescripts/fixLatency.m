uniqueSubjectIDs = unique(SubjectID);

latency = [];
stamp = [];
subjectid = [];
for n = 1 : length(uniqueSubjectIDs)
    n / length(uniqueSubjectIDs)
    % Find all rows for this subject id
    s = find(SubjectID == uniqueSubjectIDs(n));
    % find all the data for these rows
    stamps = LatencyStart(s);
    latencies = LatencyDurationmin(s);
    % convert stamps to datenums and round down
    datenums = floor(datenum(stamps));
    % get unique datenums
    uniquedatenums = unique(datenums);
    % loop through the unique datenums and check for duplicates
    for d = 1 : length(uniquedatenums)
        i = find(datenums == uniquedatenums(d));
        % are there duplicates?
        if length(i) > 1 
            % find the stamp closest to midnight
            [max_latency, index] = max(latencies);
            latency = [latency max_latency];
            stamp = [stamp stamps(index)];
            subjectid = [subjectid uniqueSubjectIDs(n)];
        else
            latency = [latency latencies(i)];
            stamp = [stamp stamps(i)];
            subjectid = [subjectid uniqueSubjectIDs(n)];
        end
    end
end
% Find the datenum of each latency start and round down
datenums = floor(datenum(LatencyStart));

% find all the unique datenums 
uniquedatenums = unique(datenums);

% % output the data as an Excel file
headers = {'Subject ID', 'Latency Start', 'Latency Duration (min)'};
filename = ['SleepLatency_Cleaned.xlsx'];
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(latency)
    row = {subjectid(n), datestr(stamp(n)), latency(n)};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end


