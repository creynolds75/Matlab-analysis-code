words = {'CHERRY', 'PEAR', 'BEET', 'CARROT', 'LIGHTNING', 'WINDY', ...
    'GORILLA', 'ORANGUTAN', 'ELEVATOR', 'BICYCLE', 'BIRCH', 'PLUM'};

colnames = whos;

displayed = zeros(size(ResponseID));
for c = 1 : numel(colnames)
    if strfind(colnames(c).name, 'ws_img_') ...
        & isempty(strfind(colnames(c).name, 'timing'))
        wsnum = str2double(regexprep(colnames(c).name,'ws_img_',''))
        colvals = eval(colnames(c).name);
        colvals(isnan(colvals)) = 0;
        for r = 1 : length(colvals)
            if colvals(r) == 1
                displayed(r) = wsnum;
            end
        end
    end
end

answers = zeros(size(ResponseID));

for c = 1 : numel(colnames)
    if strfind(colnames(c).name, 'ws_ans_') ...
        & isempty(strfind(colnames(c).name, 'timing'))
        colvals = eval(colnames(c).name);
        colvals(isnan(colvals)) = 0;
        answers = answers + colvals;
    end
end

correct = cell(size(ResponseID));
for a = 1:length(answers)
    if answers(a) == 1
        correct{a} = 'true';
    else
        correct{a} = 'false';
    end
end

wordsDisplayed = cell(size(ResponseID));

for d = 1 : length(displayed)
    if displayed(d) > 0
        wordsDisplayed{d} = words{displayed(d)};
    else
        wordsDisplayed{d} = 'Survey not complete';
    end
end

Subject = cell(size(ResponseID));
for s = 1 : length(Subject)
    Subject{s} = SubjectID(s);
end

% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
OADC = cell(size(ResponseID));
dates = cell(size(ResponseID));
for s = 1 : length(SubjectID);
    subjectId = SubjectID(s); 
    if isnan(subjectId)
        OADC{s} = 0;
    else
        query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
        OADC{s} = mysql(query);
    end
    dates{s} = datestr(StartDate(s));
end

mysql('close')


output = [OADC, Subject, ResponseID, dates, wordsDisplayed, correct];

filename = 'BeSmartWordSearch.xlsx';
sheet = 1;

for r = 1 : length(output)
    startCell = ['A' num2str(r)];
    row = output(r, :);
    xlswrite(filename, row, sheet, startCell);
end
