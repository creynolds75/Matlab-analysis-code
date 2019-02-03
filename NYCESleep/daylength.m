jan1 = datenum([2014 1 1 0 0 0]);


startdate = mod(weekIntactStarts(1) - jan1 + 1, 365);
enddate = mod(weekIntactStarts(end) - jan1 + 1, 365);
L = 45.5231;
day = [];
for n= 1:length(weekIntactStarts)
    J = mod(weekIntactStarts(n) - jan1 + 1, 365);
    %CBM Model
    theta=0.2163108+2*atan(0.9671396*tan(0.00860*(J-186))); %revolution angle from day of the year
    P = asin(0.39795*cos(theta)); %sun declination angle 
    %daylength (plus twilight)- 
    p=0.8333; %sunrise/sunset is when the top of the sun is apparently even with horizon
    D = 24 - (24/pi) * acos((sin(p*pi/180)+sin(L*pi/180)*sin(P))/(cos(L*pi/180)*cos(P))); 
    day = [day D];
end