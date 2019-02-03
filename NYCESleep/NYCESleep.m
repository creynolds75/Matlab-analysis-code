% First load spreadsheet with OADC and MCI values

%% Import the data, extracting spreadsheet dates in Excel serial date format
[~, ~, raw, dates] = xlsread('C:\Users\dunch\Documents\MATLAB\NYCESleep\MCI.xlsx','DOMAINS','A2:F129','',@convertSpreadsheetExcelDates);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
raw = raw(:,[1,3,4,5,6]);
dates = dates(:,2);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),dates); % Find non-numeric cells
dates(R) = {NaN}; % Replace non-numeric Excel dates with NaN

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
oadc = data(:,1);
VSTdateEVAL = datetime([dates{:,1}].', 'ConvertFrom', 'Excel', 'Format', 'MM/dd/yyyy');
vstCDR = data(:,2);
mci = data(:,3);
amci = data(:,4);
namci = data(:,5);

%% Clear temporary variables
clearvars data raw dates R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now loop through the OADCs and get the sleep values from the databasse
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

dates = [];
TST = [];
OADC = [];

% figure 
% hold on
jan2016 = datenum([2016 1 1 0 0 0]);
jun2016 = datenum([2016 6 30 23 59 59]);
for n = 20 : 30%length(oadc)
    % get sleep values where SensorSource = 2, for NYCE data
    query1 = 'SELECT Date, SleepWASO, SleepTST, SleepTripsOut, SleepLatency, SleepMIB ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = ' num2str(oadc(n)) ' '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    [qdate, qWASO, qTST, qUP, qST, qMIB] = mysql(query);
    % Trim data to be between Jan 2016 and June 2016
    i = find(qdate >= jan2016 & qdate <= jun2016);
    qdate = qdate(i);
    qTST = qTST(i);
    % find TST values == 0 and trim TST and dates
    dates = [dates qdate'];
    TST = [TST qTST'];
    OADC = [OADC oadc(n)*ones(size(qdate'))];
    %plot(qdate(qTST>0), qTST(qTST>0)/3600, '.')
    
    % let's get the TST values
    figure
    %plot(qdate(qTST>0), qTST(qTST>0)/3600, '.')
    TSTdates = qdate;
    TSTdates(qTST <= 0) = [];
    qTST(qTST <=0) = [];
    qTST = qTST/3600;
    medianTST = [];
    for d = 1 : 7 : length(TSTdates)-7
        medianTST = [medianTST median(qTST(d:d+7))];
    end
    plot(medianTST, '.-')
end
mysql('close')

% ylim([0 16])
% datetick('x')
% line([jan2016 jan2016], [0 16], 'LineWidth', 2)
% line([jun2016 jun2016], [0 16], 'LineWidth', 2)


% % now let's loop through and calculate median weekly sleep values
% count = 0;
% for n = 1 : 20%length(oadc)
%     % first get all the data for this OACD
%     i = find(OADC == oadc(n));
%     thisOADCdates = dates(i);
%     thisOADCTST = TST(i);
%     figure
%     plot(thisOADCdates, thisOADCTST)
%     title(num2str(OADC(n)))
% end
% 
% for o = 1 : length(oadc)
%     query = ['SELECT Date, SleepWASO, SleepTST, SleepTripsOut, SleepLatency, SleepMIB FROM algorithm_results.summary WHERE OADC = ' num2str(oadc(o))];
%     [qdate, qWASO, qTST, qUP, qST, qMIB] = mysql(query);
%     
%     % Find the indices of the dates between July 1, 2015 and Dec 31, 2015
%     july2015 = [2015 7 1 0 0 0];
%     dec2015 = [2015 12 31 0 0 0];
%     %trimIndices = find(qdate >= datenum(july2015) & qdate <= datenum(dec2015));
%     trimIndices = find(qWASO > 0);
%     plot(qdate(trimIndices), qWASO(trimIndices), '.')
%     %date = [date qdate(trimIndices)];
%     %WASO = [WASO
% %     date = [date qdate'];
% %     WASO = [WASO qWASO'];
% %     TST = [TST qTST'];
% %     UP = [UP qUP'];
% %     ST = [ST qST'];
% %     MIB = [MIB qMIB'];
% %     
% %     % trim data to run from July 2015 to December 2015
% %     july2015 = [7 1 2015 0 0 0];
% %     dec2015 = [12 31 2015 0 0 0];
% %     trimIndices = find(
% %     plot(date(qTST>0), qTST(qTST > 0)/3600, '.')
%     
% end
% ylim([0 12])


% datetick('x')
% 
% 
% ylabel('Total sleep time in hours')
% xlabel('Date')