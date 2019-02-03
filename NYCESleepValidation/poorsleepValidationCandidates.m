% Collect information about candidates for sleep verification study
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

% get subject IDs, OADC, and names for everybody
query = 'select idx, OADC, FName, LName from subjects_new.subjects where OADC > 0';
[idx, OADC, FName, LName] = mysql(query);

% get addresses for everyone
storedprocedure = 'call algorithm_results.getHomeHistory(25, false)';
query = 'SELECT subjectid, address, homephones, dob FROM algorithm_results.homehistory';
mysql(storedprocedure);
[addressidx, address, phone, dob] = mysql(query);

% make sure we have the most recent address for each person
uniquesubjectindices = [];
for i = 2 : length(addressidx)
    %is the number repeated?
    if addressidx(i) ~= addressidx(i-1)
        uniquesubjectindices = [uniquesubjectindices i-1];
    end
end
uniquesubjectindices = [uniquesubjectindices length(addressidx)];

addressidx = addressidx(uniquesubjectindices);
address = address(uniquesubjectindices);
phone = phone(uniquesubjectindices);
dob = dob(uniquesubjectindices);
% get rid of NaNs in dob
dob(isnan(dob)) = today;

% Set up to write to an Excel spreadsheet
xlsFilename = 'OADCsWithBadSleepDataWithAddresses.xlsx';
r = 1; sheet = 1;

% Now loop through and get sleep data for each ID
for i = 1 : length(idx)
    % Get the date and sleep data for each subject during April 2017
    query1 = 'SELECT Date, SleepTST FROM algorithm_results.summary ';
    query2 = ['WHERE OADC = ' num2str(OADC(i)) ' AND '];
    query3 = 'Date BETWEEN ''2017-04-01'' AND ''2017-04-30'' ';
    query = [query1 query2 query3];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    length(qTST);
    if length(qTST) < 30 & length(qdate) > 0
        query
        % get the address for this person
        addressindex = find(addressidx == idx(i));
        currentaddress = address(addressindex);
        currentphone = phone(addressindex);
        currentdob = dob(addressindex);
        % write our information to spreadsheet
        row = {idx(i), OADC(i), FName{i}, LName{i}, currentaddress{:}, currentphone{:}, datestr(currentdob)};
        cell = ['A' num2str(r)];
        %xlswrite(xlsFilename, row, sheet, cell);
        r = r + 1;
    end    
end

mysql('close')
