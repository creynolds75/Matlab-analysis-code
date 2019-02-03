% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
OADC = cell(size(allSubject));

for s = 1 : length(allSubject);
    subjectId = allSubject(s); 
    if isnan(subjectId)
        OADC{s} = 0;
    else
        query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
        OADC{s} = mysql(query);
    end
end

mysql('close')


filename = 'TypingTimesTest.xls';
sheet = 1;
for t = 1 : length(allT)
    startCell = ['A' num2str(t)];
    row = {OADC{t}, allSubject(t), allT(t), allDate{t}};
    xlswrite(filename, row, sheet, startCell);
end