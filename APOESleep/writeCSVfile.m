filename = 'APOEdata.txt'    
fileID = fopen(filename, 'w')
for n = 1 : length(OADC)
    fprintf(fileID, '%i, %s, %s, %f \n', OADC(n), Genestatus{n}, unixtime(n), HoursAsleep(n))
end
fclose(fileID)
