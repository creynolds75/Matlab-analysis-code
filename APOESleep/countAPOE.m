n22or23 = 0;
n33 = 0;
n4 = 0;
nMCI = 0;
for n = 1 : length(SPCgene1)
    if vstCDR(n) == 0
        if strcmp(SPCgene1{n}, '2,2') | strcmp(SPCgene1{n}, '2,3')
            n22or23 = n22or23+1;
        elseif strcmp(SPCgene1{n}, '3,3')
            n33 = n33+1;
        else
            n4 = n4 + 1;
        end
    
    else
        nMCI = nMCI + 1;
    end
end