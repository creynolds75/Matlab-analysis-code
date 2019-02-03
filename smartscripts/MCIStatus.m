% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
SurveyOADC = zeros(size(SubjectID));
for s = 1 : length(SubjectID);
    if ~isnan(SubjectID(s))
    query = ['select OADC from subjects_new.subjects where idx = '  num2str(SubjectID(s)) ];
    SurveyOADC(s) = mysql(query);
    end
end
mysql('close')

for n = 1 : length(SurveyOADC)
    if SurveyOADC(n) > 0
        i = find(oadc == SurveyOADC(n));
        if mci(i) > 0
            disp([num2str(oadc(i)) ' : ' num2str(mci(i))])
        end
    end
end