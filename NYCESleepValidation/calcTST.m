% Get the AW hours before midnight
AWhour = hour(AWBedTime);
AWmin = minute(AWBedTime);
for n = 1 : length(AWhour)
    if AWhour(n) > 12
        AWbeforemidnight(n) = 24 - (AWhour(n) + AWmin(n)/60);
    else
        AWbeforemidnight(n) = -(AWhour(n) + AWmin(n)/60);
    end
end

AWhour = hour(AWWakeTime);
AWmin = minute(AWWakeTime);
AWaftermidnight = AWhour + AWmin/60;

AWTST = AWbeforemidnight' + AWaftermidnight;


%%%%%%%%%
% Get the AW hours before midnight
Nhour = hour(NYCEBedTime);
Nmin = minute(NYCEBedTime);
for n = 1 : length(Nhour)
    if Nhour(n) > 12
       Nbeforemidnight(n) = 24 - (Nhour(n) + Nmin(n)/60);
    else
        Nbeforemidnight(n) = -(Nhour(n) + Nmin(n)/60);
    end
end

Nhour = hour(NYCEWakeTime);
Nmin = minute(NYCEWakeTime);
Naftermidnight = Nhour + Nmin/60;

NTST = Nbeforemidnight' + Naftermidnight;