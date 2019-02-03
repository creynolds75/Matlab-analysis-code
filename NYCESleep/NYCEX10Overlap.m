clear all

% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

% get list of subject IDs
query = 'SELECT OADC, HomeId, idx FROM subjects_new.subjects ';
[OADC, HomeId, SubjectId] = mysql(query);

r = 1;
for s = 1 : length(SubjectId)
    query = ['SELECT Date FROM algorithm_results.summary WHERE SubjectID = ' num2str(SubjectId(s)) ' AND SensorSource = 1 '];
    X10Dates = mysql(query);

    query = ['SELECT Date FROM algorithm_results.summary WHERE SubjectID = ' num2str(SubjectId(s)) ' AND SensorSource = 2 '];
    NYCEDates = mysql(query);
  
    filename = 'X10NYCEOverlap.xlsx';
    sheet = 1; 
    if ~isempty(X10Dates) & ~isempty(NYCEDates)
        %for x = 1 : length(X10Dates)
            U = intersect(X10Dates, NYCEDates);
            length(U)
            row = {SubjectId(s), OADC(s), HomeId(s), datestr(U(1)), datestr(U(end))};
             startCell = ['A' num2str(r)];
            xlswrite(filename, row, sheet, startCell);
            r = r + 1;
            disp(num2str(s/length(SubjectId)))
       % end
    end
end

mysql('close')