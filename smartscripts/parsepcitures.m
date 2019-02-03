% INCLUDE NEW PICTURES ADDED TO SURVEY
picturetypes = {'compass', 'coin', 'egg', 'grater', 'feather', 'camera', ...
    'dolls', 'bear', 'box', 'typewriter', 'skate', 'basket'};

numRows = length(ResponseID);
picturedisplayed = {};
displaycode = zeros(numRows,1);
colnames = whos;

% check over each 
power = 0.1;

for p = 1 : length(picturetypes) 
    power = power * 10;
    for c = 1 : numel(colnames)
        picturetype = picturetypes{p};
        if strfind(colnames(c).name, picturetype)
            if isempty(strfind(colnames(c).name, 'recall'))
                add = str2double(regexprep(colnames(c).name,picturetype,''));
                code = power*add;
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
for n = 1 : length(displaycode)
    displayed{n} = displaypic{displaycode(n)};
end


for p = 1 : length(picturetypes) 
    for c = 1 : numel(colnames)
        picturetype = picturetypes{p};
        if strfind(colnames(c).name, [picturetype '_recall'])
            colvals = eval(colnames(c).name);
            for n = 1 : length(colvals)
                if ~isnan(colvals(n))
                    chosen{n} = [picturetype num2str(colvals(n))];
                end
            end
        end  
    end
end

for n = 1 : length(chosen)
    if strcmp(chosen{n}, displayed{n})
        match{n} = 'true';
    else
        match{n} = 'false';
    end
end
output = [ResponseID, displayed', chosen', match'];