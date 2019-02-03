% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

allOADC = [];
for s = 1 : length(allSubject)
    subjectId = allSubject(s);
    query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
    OADC = mysql(query);
    allOADC = [allOADC OADC];
end   
mysql('close')
oadcMatched = [];
T = [];
mciCode = [];
for n = 1 : length(oadc)
    i = find(allOADC == oadc(n));
    oadcMatched = [oadcMatched allOADC(i)];
    T = [T allT(i)];
    mciCode = [mciCode ones(size(i))*mci(n)];
end
del = find(T > 60);
T(del) = [];
mciCode(del) = [];
del = find(T == 0);
T(del) = [];
mciCode(del) = [];
mci0 = find(mciCode == 0);
mci1 = find(mciCode == 1);

figure
hold on
histogram(T(mci0), 20)

histogram(T(mci1),20)
