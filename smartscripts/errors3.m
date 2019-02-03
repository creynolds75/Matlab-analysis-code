
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

for n = 1 : length(motor1)
    if isempty(motor1{n})
        numErrors1(n) = NaN;
    else
        numErrors1(n) = MinimumStringDistance(answer1, motor1{n});
    end
end

for n = 1 : length(motor2)
    if isempty(motor2{n})
        numErrors2(n) = NaN;
    else
        numErrors2(n) = MinimumStringDistance(answer2, motor2{n});
    end
end

for n = 1 : length(motor3)
    if isempty(motor3{n})
        numErrors3(n) = NaN;
    else
        numErrors3(n) = MinimumStringDistance(answer3, motor3{n});
    end
end

for n = 1 : length(motor4)
    if isempty(motor4{n})
        numErrors4(n) = NaN;
    else
        numErrors4(n) = MinimumStringDistance(answer4, motor4{n});
    end
end

for n = 1 : length(motor5)
    if isempty(motor5{n})
        numErrors5(n) = NaN;
    else
        numErrors5(n) = MinimumStringDistance(answer5, motor5{n});
    end
end

for n = 1 : length(motor6)
    if isempty(motor6{n})
        numErrors6(n) = NaN;
    else
        numErrors6(n) = MinimumStringDistance(answer6, motor6{n});
    end
end

for n = 1 : length(motor7)
    if isempty(motor7{n})
        numErrors7(n) = NaN;
    else
        numErrors7(n) = MinimumStringDistance(answer7, motor7{n});
    end
end

for n = 1 : length(motor8)
    if isempty(motor8{n})
        numErrors8(n) = NaN;
    else
        numErrors8(n) = MinimumStringDistance(answer8, motor8{n});
    end
end

for n = 1 : length(motor9)
    if isempty(motor9{n})
        numErrors9(n) = NaN;
    else
        numErrors9(n) = MinimumStringDistance(answer9, motor9{n});
    end
end

for n = 1 : length(motor10)
    if isempty(motor10{n})
        numErrors10(n) = NaN;
    else
        numErrors10(n) = MinimumStringDistance(answer10, motor10{n});
    end
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
subjId = cell(size(ResponseID));
err1 = cell(size(ResponseID));
err2 = cell(size(ResponseID));
err3 = cell(size(ResponseID));
err4 = cell(size(ResponseID));
err5 = cell(size(ResponseID));
err6 = cell(size(ResponseID));
err7 = cell(size(ResponseID));
err8 = cell(size(ResponseID));
err9 = cell(size(ResponseID));
err10 = cell(size(ResponseID));
for s = 1 : length(SubjectID);
    subjectId = SubjectID(s); 
    if isnan(subjectId)
        OADC{s} = 0;
    else
        query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
        OADC{s} = mysql(query);
    end
    dates{s} = datestr(StartDate(s));
    subjId{s} = SubjectID(s);
    err1{s} = numErrors1(s);
    err2{s} = numErrors2(s);
    err3{s} = numErrors3(s);
    err4{s} = numErrors4(s);
    err5{s} = numErrors5(s);
    err6{s} = numErrors6(s);
    err7{s} = numErrors7(s);
    err8{s} = numErrors8(s);
    err9{s} = numErrors9(s);
    err10{s} = numErrors10(s);
end

mysql('close')

output = [OADC, subjId, ResponseID, dates, err1, err2, err3, err4, err5, ...
    err6, err7, err8, err9, err10];

filename = 'BeSmartTypingErrors.xlsx';
sheet = 1;
row = {'OADC', 'SubjectID', 'ResponseID', 'StartDate', 'Motor1Err', 'Motor2Err', ...
    'Motor3Err', 'Motor4Err', 'Motor5Err', 'Motor6Err', 'Motor7Err', 'Motor8Err', ...
    'Motor9Err', 'Motor10Err'};
xlswrite(filename, row, sheet, 'A1');
for r = 1 : length(output)
    startCell = ['A' num2str(r+1)];
    row = output(r, :);
    xlswrite(filename, row, sheet, startCell);
end