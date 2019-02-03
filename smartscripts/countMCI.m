del = isnan(SubjectID);
SubjectID(del) = [];
subjectIds = unique(SubjectID);

% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
numCDR0 = 0;
numCDR1 = 0;
for s = 1 : length(subjectIds)
    query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectIds(s)) ]; 
    OADC = mysql(query);
    disp(['Subject Id ' num2str(subjectIds(s)) ' OADC ' num2str(OADC)])
    i = find(oadc==OADC);
    if ~isempty(i)
        CDR = mci(max(i));
        if CDR == 0
            numCDR0 = numCDR0+1;
        else
            numCDR1 = numCDR1+1;
        end
    end
end   
mysql('close')