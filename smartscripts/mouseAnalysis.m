D = [];
Delta = [];
K = [];
T = [];
mciCode = [];
oadcMatched = [];
for n = 1 : length(oadc)
    i = find(allOADC == oadc(n));
    oadcMatched = [oadcMatched allOADC(i)];
    D = [D allD(i)];
    Delta = [Delta allDelta(i)];
    K = [K allK(i)];
    T = [T allT(i)];
    mciCode = [mciCode ones(size(i))*mci(n)];
end


figure
hold on
% Delta = straight line
% D = actual distance
plot(Delta, D, '.')
for n = 1 : length(mciCode)
    if mciCode(n) == 1
        plot(Delta(n), D(n), 'ro')
    end
end
xlabel('Straight Line distance')
ylabel('Actual Distance')


% let's histogram T
del = find(T < 0);
T(del) = [];
mciCode(del) = [];
del = find(T > 5);
T(del) = [];
mciCode(del) = [];
mci0 = find(mciCode == 0);
mci1 = find(mciCode == 1);

figure
hold on
histogram(T(mci0))
histogram(T(mci1))
legend('CDR = 0', 'CDR = 1')
title('Histogram of Mouse Times')
xlabel('Sec')

figure 
hold on
% histogram(K(mci0));
% 
% histogram(K(mci1))
C = hist(K(mci0));
C = C ./ sum(C);


C2 = hist(K(mci1));
C2 = C2 ./ sum(C2);

barrows = [C; C2];
bar(barrows')
set(gca, 'XTick', linspace(1, 10, 10));
set(gca, 'XTickLabel', {'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', ...
    '0.8', '0.9', '1.0'});
legend('CDR = 0', 'CDR = 1')


