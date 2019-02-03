load('mci.mat')

countIntact = 0;
countaMCI = 0;
countnaMCI = 0;

for n = 1 : length(mci)
    if mci(n) == 0
        countIntact = countIntact + 1;
    else
        if amci(n) == 1
            countaMCI = countaMCI + 1;
        else
            countnaMCI = countnaMCI + 1;
        end
    end
end