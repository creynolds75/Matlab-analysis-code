numClicks = [];
% Loop through Subject IDs
for s = 1 : length(SubjectID)
    subjectId = SubjectID(s);
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
            num2str(subjectId) '&ym=20171&p=' num2str(page) '&sv=8wEcKa486I0Jenj'];
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
        % group the mouse positions into movements separated by clicks
        %figure
        %title(['Subject ID ' num2str(subjectId)])
        %hold on
        % plot positions of mouse clicks and number those clicks
        %plot(mousex(trailsClicks), mousey(trailsClicks), 'ro')
        %for n = 1 : length(trailsClicks)
        %    text(mousex(trailsClicks(n))+5, mousey(trailsClicks(n)), num2str(n), 'FontSize', 12)
        %end

        for c = 2:length(trailsClicks)
            section = trailsClicks(c-1):trailsClicks(c);
            %plot(mousex(section), mousey(section))
            % does the mouse cursor info contain -1?
            containsNegOne = 0;
            if min(mousex(section)) == -1
                containsNegOne = 1;
               % plot(mousex(section), mousey(section), '--')
            end
            if containsNegOne == 0
               % plot(mousex(section), mousey(section))
            end
            dx = [dx diff(mousex(section))];
            dy = [dy diff(mousey(section))];
            dt = [dt diff(stamp(section))];
            t = [t stamp(section(2):section(end))];
            tclicks = [tclicks stamp(section(1))];
        end
        set(gca,'Ydir','reverse')
    end

%     figure
%     hold on
% 
if length(t) > 0
     tclicks = tclicks - t(1);
     tclicks = [tclicks t(end)-t(1)];
         disp(['Subject ID ' num2str(subjectId) ' has ' num2str(length(tclicks)) ' clicks'])
else
    disp(['Subject ID ' num2str(subjectId) ' has 0 clicks'])
    rawdata
end
% 
 if length(t) > 0
numClicks = [numClicks length(tclicks)];
if length(tclicks) > 0%8 & length(tclicks) < 13
    figure
    title(['Subject ID ' num2str(subjectId)])
    hold on
    plot(mousex(trailsClicks), mousey(trailsClicks), 'ro')
    for n = 1 : length(trailsClicks)
       text(mousex(trailsClicks(n))+5, mousey(trailsClicks(n)), num2str(n), 'FontSize', 12)
    end
    set(gca,'Ydir','reverse')
    for c = 2:length(trailsClicks)
        section = trailsClicks(c-1):trailsClicks(c);
        plot(mousex(section), mousey(section))
    end
end
    dist = sqrt(dx.^2 + dy.^2);
    vel = dist ./ dt;
    t = t - t(1);
    plot(tclicks, 0, 'ro')
    for n = 1 : length(tclicks)
        text(tclicks(n)-0.25, 200, num2str(n), 'FontSize', 12)
    %     plot([tclicks(n) tclicks(n)], [0 max(vel)], 'r')
    end
    ylim([0 max(vel)])
    xlabel('Time (sec)')
    ylabel('Velocity (pixels/sec)')
    title(['Mouse velocity for trails test for Subject ' num2str(subjectId)])

    plot(t, vel)




    %%%%%%%%%%%%%%%%%%%%%%
    mind = 100;
    timeindex = zeros(size(tclicks)-1);
    for n = 1 : length(tclicks)
        tc = tclicks(n);
        mind = 100;
        for i = 1 : length(t)
            d = abs(tc-t(i));
            if d < mind;
                mind = d;
                timeindex(n) = i;
            end
        end
    end

    for n = 1 : length(timeindex)-1
        section = timeindex(n) : timeindex(n+1);
        plot(t(section), vel(section))
        [~, maxv] = max(vel(section));
        maxVIndex = maxv+section(1)-1;
        plot(t(maxVIndex), vel(maxVIndex), 'go')
          text(t(maxVIndex), vel(maxVIndex), num2str(n), 'FontSize', 12)
        hesitation = t(maxVIndex) - t(section(1))
    end

 end
end