% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

% This works with the spreadsheet seasonalSleepDemographics.xlsx
o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
TST = [];
date = [];

for n = 1 : length(OADC)
    if MCIGroup(n) == 0
        query1 = 'SELECT Date, SleepTST ';
        query2 = 'FROM algorithm_results.summary ';
        query3 = ['WHERE OADC = ' num2str(OADC(n)) ' '];
        query4 = ['AND SensorSource = 2 '];
        query = [query1 query2 query3 query4];
        [qdate, qTST] = mysql(query);
        qTST = qTST/3600;
        del = find(qTST > 24 | qTST <= 0);
        qTST(del) = [];
        qdate(del) = [];
        
        TST = [TST qTST'];
        date = [date qdate'];
    end   
end
mysql('close')

meanTST = [];
meanDate = [];
for d = min(date) : max(date)
    i = find(date == d);
    length(i)
    
    meanTST = [meanTST mean(TST(i), 'omitnan')];
    meanDate = [meanDate d];
end

% cut off first month
meanTST = meanTST(30:700);
meanDate = meanDate(30:700);
figure
subplot(3,1,1)
plot(meanDate, meanTST)
    xt = get(gca, 'XTick')
  set(gca, 'FontSize', 8)
  
  datetick('x', 12)

  xlim([meanDate(1) meanDate(end)])
  ylim([6.5 8.5])

  title('Total Sleep Time - Intact')
  ylabel('Hours')
  
  
L = 45.5231;
d = 1;
for J=52:(356+365)
    %CBM Model
    theta=0.2163108+2*atan(0.9671396*tan(0.00860*(J-186))); %revolution angle from day of the year
    P = asin(0.39795*cos(theta)); %sun declination angle 
    %daylength (plus twilight)- 
    p=0.8333; %sunrise/sunset is when the top of the sun is apparently even with horizon
    D = 24 - (24/pi) * acos((sin(p*pi/180)+sin(L*pi/180)*sin(P))/(cos(L*pi/180)*cos(P))); 
    nightlength(d) = 24 - D;
    d = d + 1;
end

subplot(3,1,2)
plot(nightlength)