fileID = fopen('data.txt', 'w')

fprintf(fileID, '%i, %s, %s, %f \n', OADC(1), SPCgene1{1}, datestr(qdate(1)), qTST(1))

fclose(fileID)