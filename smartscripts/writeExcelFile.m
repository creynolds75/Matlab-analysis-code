filename = 'besmartmouseJan.xlsx';
sheet = 1;
allD = [];
allDelta = [];
allK = [];
allT = [];
allOADC = [];
for n = 1 : length(output)
    startCell = ['A' num2str(n)];
    Delta = output(n).Delta;
    D = output(n).D;
    K = output(n).K;
    T = output(n).T;
    allD = [allD D];
    allDelta = [allDelta Delta];
    allK = [allK K];
    allT = [allT T];
    OADC = output(n).OADC;
    allOADC = [allOADC OADC];
    date = output(n).date;
    row = {OADC, datestr(date), Delta, D, K, T};
    xlswrite(filename, row, sheet, startCell);
end