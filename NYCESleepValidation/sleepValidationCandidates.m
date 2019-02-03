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
query = 'SELECT subjectid, address, homephones FROM algorithm_results.homehistory';
mysql(storedprocedure);
[addressidx, address, phone] = mysql(query);

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

% Set up to write to an Excel spreadsheet
xlsFilename = 'OADCsWithGoodSleepDataWithAddresses.xlsx';
r = 1; sheet = 1;

% Now loop through and get sleep data for each ID
for i = 1 : length(idx)
    % Get the date and sleep data for each subject during January 2017
    query1 = 'SELECT Date, SleepTST FROM algorithm_results.summary ';
    query2 = ['WHERE OADC = ' num2str(OADC(i)) ' AND '];
    query3 = 'Date BETWEEN ''2017-01-01'' AND ''2017-01-31'' ';
    query = [query1 query2 query3];
    [qdate, qTST] = mysql(query);
    qTST = qTST/3600;
    
    % if we have sleep data collected for each day in January, write that 
    % person to our list of candidates
    if length(qTST) == 31 & ~isnan(qTST) & mean(qTST) > 4
        % get the address for this person
        addressindex = find(addressidx == idx(i));
        currentaddress = address(addressindex)
        currentphone = phone(addressindex);
        % write our information to spreadsheet
        row = {idx(i), OADC(i), FName{i}, LName{i}, currentaddress{:}, currentphone{:}, mean(qTST)};
        cell = ['A' num2str(r)];
        xlswrite(xlsFilename, row, sheet, cell);
        r = r + 1;
    end    
end

mysql('close')
