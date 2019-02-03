% import email  from BESMART_March_History
% this will be called Email_History

% next import subject id and email from ORCATECH_Research_Participants
% this will be called Email and SubjectID

% get the subjectID for each email in Email_History
SubjectID_History = [];
for email = 1 : length(Email_History)
    indices = strmatch(Email_History{email}, Email, 'exact')
end

% find the OADC for each subject ID 

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

% Now find the OADC numbers for each Subject ID
OADC_SubjectID = cell(size(SubjectID));
LName = cell(size(SubjectID));
for s = 1 : length(SubjectID);
    subjectId = SubjectID(s); 
    if isnan(subjectId)
        OADC_SubjectID{s} = 0;
    else
        query = ['select OADC, LName from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
        [OADC_SubjectID{s}, LName{s}] = mysql(query);
    end
end

mysql('close')





