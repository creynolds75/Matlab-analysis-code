filename = 'DecTrailsTimes.xls';
sheet = 1;
for t = 1 : length(trailsDate)
    startCell = ['A' num2str(t)];
    row = {trailsOADC(t), datestr(trailsDate(t)), trailsTimes(t)};
    xlswrite(filename, row, sheet, startCell);
end