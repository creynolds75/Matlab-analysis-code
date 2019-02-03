% INCLUDE NEW PICTURES ADDED TO SURVEY
picturetypes = {'compass', 'coin', 'egg', 'grater', 'feather', 'camera', ...
    'dolls', 'bear', 'box', 'typewriter', 'skate', 'basket'};

numRows = length(ResponseID);
picturedisplayed = {};
displaycode = zeros(numRows,1);
colnames = whos;

% check over each 
factor = 2;

for p = 1 : length(picturetypes) 
    factor = factor * 2;
    for c = 1 : numel(colnames)
        picturetype = picturetypes{p};
        if strfind(colnames(c).name, picturetype)
            if isempty(strfind(colnames(c).name, 'recall')) ... 
                    & isempty(strfind(colnames(c).name, 'textboxes'))
                add = str2double(regexprep(colnames(c).name,picturetype,''));
                code = factor+add;
                disp([picturetype ' ' colnames(c).name ' code:' num2str(code)]);
                colvals = eval(colnames(c).name);
                colvals(isnan(colvals)) = 0;
                displaypic{code} = colnames(c).name;
                displaycode = displaycode + code*colvals;  
            end
        end  
    end
end

% figure out which was displayed
clear displayed
for n = 1 : length(displaycode)
    if displaycode(n) > 0
        displayed{n} = displaypic{displaycode(n)};
    else
        displayed{n} = displaypic{displaycode(1)};
    end
end

chosen = cell(size(ResponseID));
for p = 1 : length(picturetypes) 
    for c = 1 : numel(colnames)
        picturetype = picturetypes{p};
        if strfind(colnames(c).name, [picturetype '_recall'])
            colvals = eval(colnames(c).name);
            for n = 1 : length(colvals)
                if ~isnan(colvals(n)) 
                    if colvals(n) == 100
                        chosen{n} = 'None of these';
                    elseif colvals(n) == 101
                        chosen{n} = 'I don''t remember seeing a picture';
                    else
                        chosen{n} = [picturetype num2str(colvals(n))];
                    end
                end
            end
        end  
    end
end
match = cell(size(ResponseID));
for n = 1 : length(chosen)
    if strcmp(chosen{n}, displayed{n})
        match{n} = 'true';
    else
        match{n} = 'false';
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
output = [OADC, Subject, ResponseID, dates, displayed', chosen, match];
mysql('close')

filename = 'BeSmartMemoryTask2.xlsx';
sheet = 1;

for r = 1 : length(output)
    startCell = ['A' num2str(r)];
    row = output(r, :);
    xlswrite(filename, row, sheet, startCell);
end



