% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

    query1 = 'SELECT Date, SleepTST, SleepMIB, SleepWASO, SleepLatency, SleepTripsOut ';
    query2 = 'FROM algorithm_results.summary ';
    query3 = ['WHERE OADC = 11034 '];
    query4 = ['AND SensorSource = 2 '];
    query = [query1 query2 query3 query4];
    
    [qdate, qTST, qMIB, qWASO, qLatency, qUP] = mysql(query);
    
    %convert qTST to hours
    qTST = qTST/3600;
    
    figure
    plot(qdate, qTST, '.')
    title('Total Sleep Time for OADC 11034')
    datetick('x', 12)
    ylabel('Hours')
    
    figure
    plot(qdate, qMIB, '.')
    title('Movement in Bed Events for OADC 11034')
    datetick('x', 12)
    ylabel('Sensor Firings')
    
   figure
    plot(qdate, qWASO/60, '.')
    title('Wake after Sleep Onset for OADC 11034')
    datetick('x', 12)
    ylabel('Minutes')
    
       figure
    plot(qdate, qLatency/60, '.')
    title('Sleep Latency for OADC 11034')
    datetick('x', 12)
    ylabel('Minutes')
    
       figure
    plot(qdate, qUP, '.')
    title('Trips out of Bedroom for OADC 11034')
    datetick('x', 12)
    