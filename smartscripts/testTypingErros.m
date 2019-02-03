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

% Capitalization and punctuation are not considered in calculating typing
% errors
for n = 1 : length(motor1)
    if isempty(motor1{n})
        numErrors1(n) = NaN;
    else
        motor1{n} = lower(motor1{n});
        motor1{n} = regexprep(motor1{n}, '\.', '');
        motor1{n} = regexprep(motor1{n}, '?', '');
        motor1{n} = regexprep(motor1{n}, '!', '');
        motor1{n} = regexprep(motor1{n}, ',', '');
        numErrors1(n) = MinimumStringDistance(answer1, motor1{n});
    end
end

for n = 1 : length(motor2)
    if isempty(motor2{n})
        numErrors2(n) = NaN;
    else
        motor2{n} = lower(motor2{n});
        motor2{n} = regexprep(motor2{n}, '\.', '');
        motor2{n} = regexprep(motor2{n}, '?', '');
        motor2{n} = regexprep(motor2{n}, '!', '');
        motor2{n} = regexprep(motor2{n}, ',', '');
        numErrors2(n) = MinimumStringDistance(answer2, motor2{n});
    end
end

for n = 1 : length(motor3)
    if isempty(motor3{n})
        numErrors3(n) = NaN;
    else
        motor3{n} = lower(motor3{n});
        motor3{n} = regexprep(motor3{n}, '\.', '');
        motor3{n} = regexprep(motor3{n}, '?', '');
        motor3{n} = regexprep(motor3{n}, '!', '');
        motor3{n} = regexprep(motor3{n}, ',', '');
        numErrors3(n) = MinimumStringDistance(answer3, motor3{n});
    end
end

for n = 1 : length(motor4)
    if isempty(motor4{n})
        numErrors4(n) = NaN;
    else
        motor4{n} = lower(motor4{n});
        motor4{n} = regexprep(motor4{n}, '\.', '');
        motor4{n} = regexprep(motor4{n}, '?', '');
        motor4{n} = regexprep(motor4{n}, '!', '');
        motor4{n} = regexprep(motor4{n}, ',', '');
        numErrors4(n) = MinimumStringDistance(answer4, motor4{n});
    end
end

for n = 1 : length(motor5)
    if isempty(motor5{n})
        numErrors5(n) = NaN;
    else
        motor5{n} = lower(motor5{n});
        motor5{n} = regexprep(motor5{n}, '\.', '');
        motor5{n} = regexprep(motor5{n}, '?', '');
        motor5{n} = regexprep(motor5{n}, '!', '');
        motor5{n} = regexprep(motor5{n}, ',', '');
        numErrors5(n) = MinimumStringDistance(answer5, motor5{n});
    end
end

for n = 1 : length(motor6)
    if isempty(motor6{n})
        numErrors6(n) = NaN;
    else
        motor6{n} = lower(motor6{n});
        motor6{n} = regexprep(motor6{n}, '\.', '');
        motor6{n} = regexprep(motor6{n}, '?', '');
        motor6{n} = regexprep(motor6{n}, '!', '');
        motor6{n} = regexprep(motor6{n}, ',', '');
        numErrors6(n) = MinimumStringDistance(answer6, motor6{n});
    end
end

for n = 1 : length(motor7)
    if isempty(motor7{n})
        numErrors7(n) = NaN;
    else
        motor7{n} = lower(motor7{n});
        motor7{n} = regexprep(motor7{n}, '\.', '');
        motor7{n} = regexprep(motor7{n}, '?', '');
        motor7{n} = regexprep(motor7{n}, '!', '');
        motor7{n} = regexprep(motor7{n}, ',', '');
        numErrors7(n) = MinimumStringDistance(answer7, motor7{n});
    end
end

for n = 1 : length(motor8)
    if isempty(motor8{n})
        numErrors8(n) = NaN;
    else
        motor8{n} = lower(motor8{n});
        motor8{n} = regexprep(motor8{n}, '\.', '');
        motor8{n} = regexprep(motor8{n}, '?', '');
        motor8{n} = regexprep(motor8{n}, '!', '');
        motor8{n} = regexprep(motor8{n}, ',', '');
        numErrors8(n) = MinimumStringDistance(answer8, motor8{n});
    end
end

for n = 1 : length(motor9)
    if isempty(motor9{n})
        numErrors9(n) = NaN;
    else
        motor9{n} = lower(motor{n});
        motor9{n} = regexprep(motor9{n}, '\.', '');
        motor9{n} = regexprep(motor9{n}, '?', '');
        motor9{n} = regexprep(motor9{n}, '!', '');
        motor9{n} = regexprep(motor9{n}, ',', '');
        numErrors9(n) = MinimumStringDistance(answer9, motor9{n});
    end
end

for n = 1 : length(motor10)
    if isempty(motor10{n})
        numErrors10(n) = NaN;
    else
        motor10{n} = lower(motor10{n});
        motor10{n} = regexprep(motor10{n}, '\.', '');
        motor10{n} = regexprep(motor10{n}, '?', '');
        motor10{n} = regexprep(motor10{n}, '!', '');
        motor10{n} = regexprep(motor10{n}, ',', '');
        numErrors10(n) = MinimumStringDistance(answer10, motor10{n});
    end
end
