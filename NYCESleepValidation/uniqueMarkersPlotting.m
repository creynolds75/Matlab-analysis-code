uniqueOADC = unique(OADC);
figure 
hold on
actiwatch = []; nyce = [];
for n = 1 : length(uniqueOADC)
    i = find(OADC == uniqueOADC(n));
    if uniqueOADC(n) ~= 10112
    plot(AWTST(i)/60, NYCETST(i)*60*60, '.', 'MarkerSize', 12)
    actiwatch = [actiwatch AWTST(i)'/60];
    nyce = [nyce NYCETST(i)'*60*60];
   % text(AWTST(i)/60, NYCETST(i)*60*60, num2str(uniqueOADC(n)))
    end
end
xlabel('Actiwatch')
ylabel('NYCE')
title('Total Sleep Time in Hours')