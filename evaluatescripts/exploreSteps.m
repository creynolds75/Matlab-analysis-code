% start = datenum([2017 9 1 0 0 0]);
% stop = datenum([2017 10 30 0 0 0]);
% 
% i = find(datenum(dt) > start & datenum(dt) < stop);
% dtSection = dt(i);
% stepsSection = steps(i);

i = find(SubjectID == 1520);
Date = Date(i);
TotalSteps = TotalSteps(i);

