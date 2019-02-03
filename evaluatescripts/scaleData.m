subjectids = [1516, 1517, 1520, 1521, 1526, 1527, 1558, 1559, 1564, 1565, 1576, 1577, ...
    1572, 1573, 1582, 1583, 1588, 1586, 1587, 1597, 1598, 1605, 1606, ...
    1607, 1608];

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('dunch', 'Dunch!1');
MySQL.connect(Subjects.SERVER);

Date = []; 
SubjectID = [];
HomeId = []; 
OADC = [];
ScaleWeight = []; 
ScaleImpedance = [];
ScaleHeartRate = []; 
ScaleCO2Avg = [];
ScaleCO2Median = [];
ScaleCO2STD = []; 
ScaleTempAvg = []; 
ScaleTempMedian = [];
ScaleTempSTD = [];
    
for n = 1 : length(subjectids)
    query1 = 'SELECT Date, SubjectID, HomeId, OADC, ';
    query2 = 'ScaleWeight, ScaleImpedance, ScaleHeartRate, ScaleCO2Avg, ';
    query3 = 'ScaleC02Median, ScaleC02STD, ScaleTempAvg, ScaleTempMedian, ScaleTempSTD ';
    query4 = 'FROM algorithm_results.summary ';
    query5 = ['WHERE SubjectId = ' num2str(subjectids(n)) ' '];
    query = [query1 query2 query3 query4 query5];
    [qdate, qsubjectid, qhomeid, qOADC, qScaleWeight, qScaleImpedance, qScaleHeartRate ...
        qScaleCO2Avg, qScaleCO2Median, qScaleCO2STD ...
        qScaleTempAvg, qScaleTempMedian, qScaleTempSTD] = mysql(query);
    
    Date = [Date qdate']; 
    SubjectID = [SubjectID qsubjectid'];
    HomeId = [HomeId qhomeid']; 
    OADC = [OADC qOADC'];
    ScaleWeight = [ScaleWeight qScaleWeight']; 
    ScaleImpedance = [ScaleImpedance qScaleImpedance'];
    ScaleHeartRate = [ScaleHeartRate qScaleHeartRate']; 
    ScaleCO2Avg = [ScaleCO2Avg qScaleCO2Avg'];
    ScaleCO2Median = [ScaleCO2Median qScaleCO2Median'];
    ScaleCO2STD = [ScaleCO2STD qScaleCO2STD']; 
    ScaleTempAvg = [ScaleTempAvg qScaleTempAvg']; 
    ScaleTempMedian = [ScaleTempMedian qScaleTempMedian'];
    ScaleTempSTD = [ScaleTempSTD qScaleTempSTD'];
 
end
mysql('close')

headers = {'Date', 'SubjectID', 'HomeID', 'OADC', 'ScaleWeight', 'ScaleImpedance' ...
    'ScaleHeartRate', 'ScaleCO2Avg', 'ScaleCO2Median', 'ScaleCO2STD', 'ScaleTempAvg',...
    'ScaleTempMedian', 'ScaleTempSTD'};
filename =  'EVALUATE_ScaleData_Jan23.xlsx';
xlswrite(filename, headers);
rownum = 2;

for n = 1 : length(Date)
    row = {datestr(Date(n)), SubjectID(n), HomeId(n), OADC(n), ScaleWeight(n), ...
        ScaleImpedance(n), ScaleHeartRate(n), ScaleCO2Avg(n), ScaleCO2Median(n), ...
        ScaleCO2STD(n), ScaleTempAvg(n), ScaleTempMedian(n), ScaleTempSTD(n)};
    xlswrite(filename, row, 1, ['A' num2str(rownum)]);
    rownum = rownum + 1;
end