A = [1 1 2 2 3 4 4];
% we want 2 4 5 7
r = [];
for i = 2 : length(A)
    %is the number repeated?
    if A(i) ~= A(i-1)
        r = [r i-1];
    end
end
r = [r length(A)];