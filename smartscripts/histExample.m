x = 4 * rand(1, 1000);
subplot(2,2,1);
plot(x);
xlabel('Index');
ylabel('Input Value');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

numberOfBins = 16;
[counts, binValues] = hist(x, numberOfBins);
subplot(2,2,2);
bar(binValues, counts, 'barwidth', 1);
xlabel('Input Value');
ylabel('Absolute Count');

normalizedCounts = 100 * counts / sum(counts);
subplot(2,1,2);
bar(binValues, normalizedCounts, 'barwidth', 1);
xlabel('Input Value');
ylabel('Normalized Count [%]');