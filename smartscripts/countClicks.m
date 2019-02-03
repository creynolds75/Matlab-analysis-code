numClicks = [];

% Loop through Subject IDs
for s = 1 : length(SubjectID)
    subjectId = SubjectID(s)
    % set up arrays to hold raw mouse data
    imagehovervalues = []; % true if mouse is hovering over trails image
    mousex = []; % mouse cursor x positions
    mousey = []; % mouse cursor y positions
    stamp = []; % time stamps
    mousebuttondown = []; % this equals 0 when mouse button is released
    
    % the data is pulled down in 5,000 line pages. Keep pulling down data
    % until the last page flag is true
    page = 1;
    lastpage = 0;

    while lastpage == 0
        % Get a page of data
        urltext=['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdSurveyIdYearMonth.php?s=' ...
            num2str(subjectId) '&ym=201611&p=' num2str(page) '&sv=8wEcKa486I0Jenj'];
        rawdata = urlread(urltext);

        % the raw data is formatted as a Matlab struct. Read the struct
        try
            structContents = eval(rawdata);
        % occasionally the data is corrupted - toss cases that don't work
        catch
            disp([ num2str(subjectId) ' did not work'])
            lastpage = 2;
            continue;
        end
        % collect the data from the struct
        for i = 1:length(structContents.data)
            imagehovervalues = [imagehovervalues structContents.data(i).imagehover];
            mousex = [mousex structContents.data(i).mousex];
            mousey = [mousey structContents.data(i).mousey];
            mousebuttondown = [mousebuttondown structContents.data(i).mousebuttondown];
            stamp = [stamp structContents.data(i).stamp];
        end
        % keep collecting data until lastpage is true
        page = page + 1; 
        lastpage = structContents.lastpage;
    end

    % find the indices of mouse clicks
    clickIndices = find(mousebuttondown == 0);

    % find when the cursor enters then leaves the trails image
    currentImOne = find(imagehovervalues == 1);
    currentImZero = find(imagehovervalues == 0);
    % Create arrays to hold information for calculating mouse velocity
    dx = []; dy = []; dt = []; t= []; tclicks = [];
    if ~isempty(currentImOne) & ~isempty(currentImZero)
        % the trails are marked by the first image hover value == 1 and the
        % last value == 0
        trails = currentImOne(1):currentImZero(end);
        trailsClicks = intersect(trails, clickIndices);
        numClicks = [numClicks length(trailsClicks)];
    end
end