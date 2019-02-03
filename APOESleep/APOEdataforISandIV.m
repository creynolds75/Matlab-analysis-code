e4pos = zeros(size(OADC));
e4neg = zeros(size(OADC));
e2pos = zeros(size(OADC));
for n = 1 : length(SPCgene1)
    % First let's look for all e4 genes
    if strfind(SPCgene1{n}, '4')
        e4pos(n) = 1;
    else
        e4neg(n) = 1;
    end
    % Let's find all e2 genes
    if strfind(SPCgene1{n}, '2')
        e2pos(n) = 1;
    end
end

% Get home IDs for each of the OADCs so we can collect sensor data
% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);



mysql('close')