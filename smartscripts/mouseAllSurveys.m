% manually import subject Ids and start dates from Qualtrix spreadsheet

% get OADC numbers 
% loop through all the OADC numbers
import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);

% Subject IDs are loaded from spreadsheet of survey results
del = isnan(SubjectID);
SubjectID(del) = [];
StartDate(del) = [];
subjectIds = unique(SubjectID);

index = 1;

% set up indices to hold total times for each subject's trails test
trailsTimes = [];
trailsOADC = [];
trailsDate = [];

% loop through the subject ids
for s = 1 : length(subjectIds);
    subjectId = subjectIds(s); 
    disp(['Subject ID ' num2str(subjectId)])
    query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
    OADC = mysql(query);
    date = StartDate(s);
    disp(['OADC ' num2str(OADC)])
    % Set up arrays to hold values
    imagehovervalues = [];
    mousex = [];
    mousey = [];
    mousebutton = [];
    textboxactive = [];
    stamp = [];
    mousebuttondown = []; % this equals 0 when mouse button is released
    textbox = [];
    % the data is pulled down in 5,000 line pages. Keep pulling down data
    % until the last page flag is true
    page = 1;
    lastpage = 0;
    
    while lastpage == 0
        % Get a page of data
        %urltext = ['http://juno.orcatech.org/php/loadFormsUserInputBySubjIdYearMonth.php?s=' recipientId '&ym=201610&p=' num2str(page)'];
        %urltext= ['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdYearMonth.php?s=' num2str(subjectId) '&ym=201611&p=' num2str(page)];
        urltext=['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdSurveyIdYearMonth.php?s=' num2str(subjectId) '&ym=201611&p=' num2str(page) '&sv=8wEcKa486I0Jenj'];
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
            mousebutton = [mousebutton structContents.data(i).mousebutton];
            mousebuttondown = [mousebuttondown structContents.data(i).mousebuttondown];
            stamp = [stamp structContents.data(i).stamp];
            % 1 when entering, 0 when leaving, otherwise -1
            textboxactive = [textboxactive structContents.data(i).textboxactive];
            % string when textbox active is one or zero
            structContents.data(i).textboxactive;
            if structContents.data(i).textboxactive > -1
                structContents.data(i).textbox;
            end
            textbox = [textbox structContents.data(i).textbox];
        end
        page = page + 1; 
        lastpage = structContents.lastpage;
    end
    % find the indices of mouse clicks
    clicks = find(mousebuttondown == 0);

    % find when the cursor enters then leaves the trails image
    currentImOne = find(imagehovervalues == 1);
    currentImZero = find(imagehovervalues == 0);

    if ~isempty(currentImOne) & ~isempty(currentImZero)
        % the trails are marked by the first image hover value == 1 and the
        % last value == 0
        trails = currentImOne(1):currentImZero(end);
        trailsClicks = intersect(trails, clicks);
        % group the mouse positions into movements separated by clicks
        figure
        title(['Subject ID ' num2str(subjectId) ' OADC ' num2str(OADC)])
        hold on

        plot(mousex(trailsClicks), mousey(trailsClicks), 'ro')
        for n = 1 : length(trailsClicks)
            text(mousex(trailsClicks(n))+5, mousey(trailsClicks(n)), num2str(n), 'FontSize', 12)
        end
        totalTrailsTime = 0;
        for c = 2:length(trailsClicks)
            section = trailsClicks(c-1):trailsClicks(c);
            %plot(mousex(section), mousey(section))
            % does the mouse cursor info contain -1?
            containsNegOne = 0;
            if min(mousex(section)) == -1
                containsNegOne = 1;
                plot(mousex(section), mousey(section), '--')
            end
            if containsNegOne == 0
                plot(mousex(section), mousey(section))
                % calculate statistics
                % straight line distance
                dx = mousex(section(end)) - mousex(section(1));
                dy = mousey(section(end)) - mousey(section(1));
                Delta = sqrt(dx^2 + dy^2);
                % actual distance traveled
                dx2 = diff(mousex(section));
                dy2 = diff(mousey(section));
                D = sum(sqrt(dx2.^2 + dy2.^2));
                % curvature
                K = Delta/D;
                % K = (straight line distance)/(actual distance traveled)
                % time elapsed
                T = stamp(section(end)) - stamp(section(1));
                
                % SUM UP MOUSE TIMES TO GET TOTAL TRAILS TIME
                totalTrailsTime = totalTrailsTime + T;
                
                if Delta > 0
                output(index).Delta = Delta;
                output(index).D = D;
                output(index).K = K;
                output(index).T = T;
                output(index).OADC = OADC;
                output(index).date = date;
                index = index+ 1;
                end
                % pause from the moment of the 
                pause = stamp(section(2)) - stamp(section(1));
            end
        end
        set(gca,'Ydir','reverse')
        trailsTimes = [trailsTimes totalTrailsTime];
        trailsOADC = [trailsOADC OADC];
        trailsDate = [trailsDate date];
    end
end

% clean up trails data
i = find(trailsTimes <= 5);
trailsTimes(i) =[];
trailsOADC(i) = [];
trailsDate(i) = [];

mysql('close')