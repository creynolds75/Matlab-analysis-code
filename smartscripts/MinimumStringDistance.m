% Levenshtein distance
function MSD = MinimumStringDistance(A, B)

D = zeros(length(A), length(B));

if strcmp(A, B)
    MSD = 0;
else
    for i = 1 : length(A)
        D(i, 1) = i;
    end
    
    for j = 1 : length(B)
        D(1, j) = j;
    end
    
    for i = 2 : length(A)
        for j = 2 : length(B)
            row1 = D(i-1, j) + 1;
            row2 = D(i, j-1) + 1;
            if A(i) == B(j)
                r = 0;
            else
                r = 1;
            end
            row3 = D(i-1, j-1) + r;
            D(i, j) = min([row1 row2 row3]);
        end
    end
% minimum string distance
MSD = D(length(A), length(B))-1;    
end

