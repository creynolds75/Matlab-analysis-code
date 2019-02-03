% Display time stamps and event marker for bedroom on sample day
% Thursday Feb 16 at noon through Friday Feb 17 at noon
for i = 1 : length(sampleEvents)
    disp([datestr(sampleStamps(i)) ' ' num2str(sampleEvents(i))])
end