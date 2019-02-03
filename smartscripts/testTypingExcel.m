sheet = 'Typing Times';
row = {'OADC', 'SubjectID', 'ResponseID', 'Typing Time', 'Date'};
filename = 'testtyping.xlsx';
xlswrite(filename, row, sheet, 'A1');
for t = 1 : length(allT)
    startCell = ['A' num2str(t+1)];
    row = {OADC{t}, allSubject(t), allResponseID{t}, allT(t), allDate{t}};
    xlswrite(filename, row, sheet, startCell);
end

disp('Typing errors written')