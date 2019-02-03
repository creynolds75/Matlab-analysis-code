import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

% IMPORT CARTSubjects.xlsx

% Write to an Excel file
headers = {'OADC', 'Subject ID', 'Home ID', 'Start Date', 'End Date'};
filename = ['CARTNYCESensorDates.xlsx'];
xlswrite(filename, headers);
rownum = 2;

% Loop through Home ids
for n = 1 : length(HomeID)
    n/length(HomeID)
    % Get home inventory data from data base
    MySQL.connect(Subjects.SERVER);
    query = ['CALL algorithm_results.getHomeInventoryCurrent(276,' num2str(HomeID(n)) ')'];
    [itemid, serial, itemname, mac, modelid, modelname, batteries, subjspec, vendorid, ...
        vendorname, typeid,typename, subtypidid, subtypename, battmos,...
        homeid, lastbattchange, active, activename, start, ownership, ownershiptype, ...
        statusid, statusname] = mysql(query);
    mysql('close')
    
    % convert date strings to datetime
    startDT = datetime(start, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    stopDT = today;
    % find all NYCE sensors
    j = find(vendorid == 52);
    % if there's sensors found:
    if ~isempty(j)
        % find dates associated with these sensors 
        NYCEstart = min(startDT(j));
        NYCEstop = stopDT;
        row = {OADC(n), SubjectID(n), HomeID(n), datestr(NYCEstart), datestr(NYCEstop)};
        xlswrite(filename, row, 1, ['A' num2str(rownum)]);
        rownum = rownum + 1;
    end
end
mysql('close')