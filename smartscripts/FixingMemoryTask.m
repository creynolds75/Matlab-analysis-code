%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Memory task: the memory task consists of a picture displayed at the beginning
% of the survey and a question at the end of the survey asking the user to
% choose the picture displayed from four possible choices

% Names of pictures that could possibly be displayed
picturetypes = {'compass', 'coin', 'egg', 'grater', 'feather', 'camera', ...
    'dolls', 'bear', 'box', 'typewriter', 'skate', 'basket'};
% Set up an array to hold a code generated for each column of pictures
numRows = length(ResponseID);
picturedisplayed = {};
displaycode = zeros(numRows,1);
% Get names of columns from the spreadsheet
colnames = whos;

% factor is used to generate a unique number for each column of pictures
factor = 2;
% Loop over all the possible pictures
for p = 1 : length(picturetypes) 
    % factor is used for generating unique code for each picture
    factor = factor * 2;
    for c = 1 : numel(colnames)
        picturetype = picturetypes{p};
        % find the column associated with this picture type
        % since one of the picture types is 'box' we need to exclude
        % columns containing 'textboxes
        % we'll also exclude the 'recall' columns, of which there is one
        % for each picture type to hold answerrs
        if strfind(colnames(c).name, picturetype)
            if isempty(strfind(colnames(c).name, 'recall')) ... 
                    & isempty(strfind(colnames(c).name, 'textboxes'))
                % Each of the possible answers is numbered 1 - 4. Use these
                % numbers as part of generating a unique code for each
                % possible answer
                add = str2double(regexprep(colnames(c).name,picturetype,''));
                code = factor+add;
                % get all the rows for a given column
                colvals = eval(colnames(c).name);
                colvals(isnan(colvals)) = 0;
                displaypic{code} = colnames(c).name;
                % record the code for the image that wass displayed
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
% Check the 'recall' column to determine which picture was chosen out of
% the four options
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
% Check if the chosen answer was correct or nott
match = cell(size(ResponseID));
for n = 1 : length(chosen)
    if strcmp(chosen{n}, displayed{n})
        match{n} = 'true';
    else
        match{n} = 'false';
    end
end

% Save subject IDs as a cell array to make xlswrite happy
Subject = cell(size(ResponseID));
for s = 1 : length(Subject)
    Subject{s} = SubjectID(s);
end