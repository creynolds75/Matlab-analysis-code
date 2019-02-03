%% Typing times
del = isnan(SubjectID);
SubjectID(del) = [];
StartDate(del) = [];
%subjectIds = unique(SubjectID);

allT = [];
allSubject = [];
allDate = [];
allResponseID = [];
allTextbox = [];
for s = 1 : 1%length(SubjectID);
    subjectId = SubjectID(s);
    thisdate = StartDate(s);
    response = ResponseID(s);
    % set up arrays to hold textbox status and time stamp values
    stamp = [];
    textbox = [];
    t = 1;
    % the data is pulled down in 5,000 line pages. Keep pulling down data
    % until the last page flag is true
    page = 1;
    lastpage = 0;
    while lastpage == 0
        %urltext= ['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdSurveyIdYearMonth.php?s=' num2str(subjectId) '&ym=201611&p=' num2str(page) '&sv=8wEcKa486I0Jenj']
        urltext1= 'https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdYearMonth.php?s=';
        urltext2 = [num2str(subjectId) '&ym=201611&p=' num2str(page)];
        urltext = [urltext1 urltext2];
        rawdata = urlread(urltext);
        
        % the raw data is formatted as a Matlab struct. Read the struct
        try
            structContents = eval(rawdata);
        catch
            disp([ num2str(subjectId) ' did not work'])
            lastpage = 2;
            continue
        end
        % collect the data from the struct
        for i = 1:length(structContents.data)
            stamp = [stamp structContents.data(i).stamp];
            textbox{t} = structContents.data(i).textbox;
            t = t + 1;
        end
        page = page + 1; 
        lastpage = structContents.lastpage;
    end
    % There are up to ten text boxes with start and stop times recorded
    % Set up an array to hold these possible values
    for i = 1 : 10
        textarray(i).times = 0;
    end
    
    % Loop through all the rows of data for this survey
    for i = 1 : length(textbox)
        % if a text box was active, the textbox value will not be equal to
        % -1. It will contain the label of the active text box, such as
        % 'motor1'
        
        if strcmp(textbox{i}, '-1') == 0
            textbox{i}
            index = str2double(strrep(textbox{i}, 'motor', ''));
            if ~isnan(index)
                textarray(index).times = [textarray(index).times stamp(i)]
            end
        end
    end
    
%     for n = 1 : length(textarray)
%         textarray(n).times
%     end
    % Loop through the array of collected time stamps
    for i = 1 : 10
        % get the collected time stamps for a certain text box
        times = textarray(i).times;
        % each list will have at least one value, since we seeded the array
        % with zeros before collecting values. Ideally, the box should then
        % three values - the zero, the start time and end time. If we have
        % the right number of values, calculate the typing time
        if length(times) >= 3
            textarray(i).typingtime = times(end) - times(2);
            disp(['Time 1: ' num2str(times(2)) ' time 2: ' num2str(times(end))])
            disp(['Typing time for box ' num2str(i) ' and subject ' num2str(subjectId) ': ' num2str(times(3) - times(2))])
            allT = [allT times(3) - times(2)];
            allSubject = [allSubject subjectId];
            allDate = [allDate thisdate];
            allResponseID = [allResponseID response];
            allTextbox = [allTextbox i];
            % sometimes a value isn't captured for the start or end of typing.
        % In that case, save a NaN value for this text box.
        else
            textarray(i).typingtime = NaN;
        end
    end
end

