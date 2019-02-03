% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

OADC = cell(size(SubjectID));
subjId = cell(size(SubjectID));
MCI = cell(size(SubjectID));
for s = 1 : length(SubjectID);
    if ~isnan(SubjectID(s))
        query = ['select OADC from subjects_new.subjects where idx = '  num2str(SubjectID(s)) ];
        OADC{s} = mysql(query);
    end
end
mysql('close')



output = [OADC, subjId];
% filename = 'BeSmartOADCs.xlsx';
% sheet = 1;
% row = {'OADC', 'SubjectID'};
% xlswrite(filename, row, sheet, 'A1');
% for r = 1 : length(output)
%     startCell = ['A' num2str(r+1)];
%     row = output(r, :);
%     xlswrite(filename, row, sheet, startCell);
% end