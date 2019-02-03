% get all the unique OADCs
uniqueOADCs = unique(oadc1);

%loop through the unique OADCs
for n = 1 : length(uniqueOADCs)
    % find indices for this OADC
    i = find(oadc1 == uniqueOADCs(n));
    % find CDR vals for this OADC
    CDRs = vstCDR1(i);
    change = max(CDRs) - min(CDRs);
    
    if change >= 1
        disp([num2str(uniqueOADCs(n)) ' changed by ' num2str(change)])
    end
end