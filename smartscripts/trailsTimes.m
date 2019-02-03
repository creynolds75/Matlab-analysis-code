% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
OADC = cell(size(ResponseID));
dates = cell(size(ResponseID));
subjId = cell(size(ResponseID));
trailtimes = cell(size(ResponseID));
trails_times = trails_timing_2 - trails_timing_1;
for s = 1 : length(SubjectID);
    subjectId = SubjectID(s); 
    if isnan(subjectId)
        OADC{s} = 0;
    else
        query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
        OADC{s} = mysql(query);
    end
    %dates{s} = StartDate(s);
    dates{s} = datestr(StartDate(s));
    subjId{s} = SubjectID(s);
    trailtimes{s} = trails_times(s);
end
mysql('close')

output = [OADC, subjId, ResponseID, dates, trailtimes];
filename = 'BeSmartTrailsTimes.xlsx';
sheet = 1;
row = {'OADC', 'SubjectID', 'ResponseID', 'StartDate', 'TrailTimes'};
xlswrite(filename, row, sheet, 'A1');
for r = 1 : length(output)
    startCell = ['A' num2str(r+1)];
    row = output(r, :);
    xlswrite(filename, row, sheet, startCell);
end