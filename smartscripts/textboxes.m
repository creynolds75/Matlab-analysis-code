month = 11; 
year = 2016;

for s = 1 : length(SubjectID)
    
    subjectId = SubjectID(s);

    urltext1='https://juno.orcatech.org/php/healthforms/loadSurveysBySubjIdSurveyIdYearMonth.php?';
    urltext2=['s=' num2str(subjectId) '&sv=SV_8wEcKa486I0Jenj&y=' num2str(year) '&m=' num2str(month)];
    rawdata = urlread([urltext1 urltext2]);

    % the raw data is formatted as a Matlab struct. Read the struct
    try
        structContents = eval(rawdata);
    % occasionally the data is corrupted - toss cases that don't work
    catch
        disp([num2str(subjectId) ' did not work'])
        continue
    end
    disp(['Working on ' num2str(subjectId)])
    answer1 = 'the sun rises in the east';
    answer2 = 'did you have a good time';
    answer3 = 'space is a high priority';
    answer4 = 'you are a wonderful example';
    answer5 = 'what you see is what you get';
    answer6 = 'do not say anything';
    answer7 = 'all work and no play';
    answer8 = 'hair gel is very greasy';
    answer9 = 'the dreamers of dreams';
    answer10 = 'all together in one big pile';

    motor1 = structContents.data.motor1;
    motor2 = structContents.data.motor2;
    motor3 = structContents.data.motor3;
    motor4 = structContents.data.motor4;
    motor5 = structContents.data.motor5;
    motor6 = structContents.data.motor6;
    motor7 = structContents.data.motor7;
    motor8 = structContents.data.motor8;
    motor9 = structContents.data.motor9;
    motor10 = structContents.data.motor10;

    if isempty(motor1)
        err1 = NaN;
    else
        err1 = MinimumStringDistance(answer1, motor1);
    end
    if isempty(motor2)
        err2 = NaN;
    else 
        err2 = MinimumStringDistance(answer2, motor2);
    end
    if isempty(motor3)
        err3 = NaN;
    else
        err3 = MinimumStringDistance(answer3, motor3);
    end
    if isempty(motor4)
        err4 = NaN;
    else
        err4 = MinimumStringDistance(answer4, motor4);
    end
    if isempty(motor5)
        err5 = NaN;
    else
        err5 = MinimumStringDistance(answer5, motor5);
    end
    if isempty(motor6)
        err6 = NaN;
    else
        err6 = MinimumStringDistance(answer6, motor6);
    end
    if isempty(motor7)
        err7 = NaN;
    else
        err7 = MinimumStringDistance(answer7, motor7);
    end
    if isempty(motor8)
        err8 = NaN;
    else
        err8 = MinimumStringDistance(answer8, motor8);
    end
    if isempty(motor9)
        err9 = NaN;
    else
        err9 = MinimumStringDistance(answer9, motor9);
    end
    if isempty(motor10)
        err10 = NaN;
    else
        err10 = MinimumStringDistance(answer10, motor10);
    end
end