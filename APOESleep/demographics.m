age = [];
age4plus = [];
 age4minus = [];
sex = [];
sex4plus = [];
sex4minus = [];
MMSE = [];
MMSE4plus = [];
MMSE4minus = [];
e4pluscount = 0;
e4minuscount = 0;
selfreport4plus = [];
selfreport4minus = [];
for n = 1 : length(OADC)
    if vstCDR(n) == 0
        age = [age VSTage(n)];
        sex = [sex Rsex(n)];
        MMSE = [MMSE vstMMSE(n)];
        if strfind(SPCgene1{n}, '4')
            e4pluscount = e4pluscount + 1;
            age4plus = [age4plus VSTage(n)];
            sex4plus = [sex4plus Rsex(n)];
            MMSE4plus = [MMSE4plus vstMMSE(n)];
            selfreport4plus = [selfreport4plus SelfReportSleep(n)];
        else
            e4minuscount = e4minuscount + 1;
            age4minus = [age4minus VSTage(n)];
            sex4minus = [sex4minus Rsex(n)];
            MMSE4minus = [MMSE4minus vstMMSE(n)];
            selfreport4minus = [selfreport4minus SelfReportSleep(n)];
        end
    end
end