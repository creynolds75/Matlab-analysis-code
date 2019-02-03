lev = 7;
intactDenoised = wden(dailyAverageIntact,'heursure','s','one',lev,'sym8');
figure
hold on
plot(intactdates, dailyAverageIntact, '.')
plot(intactdates, intactDenoised)
ylim([6 9])
datetick('x', 12)
title('Intact TST Denoised')

amciDenoised = wden(dailyAverageAmci,'heursure','s','one',lev,'sym8');
figure
hold on
plot(amcidates, dailyAverageAmci, '.')
plot(amcidates, amciDenoised)
ylim([6 11])
datetick('x', 12)
title('aMCI TST Denoised')

namciDenoised = wden(dailyAverageNamci,'heursure','s','one',lev,'sym8');
figure
hold on
plot(namcidates, dailyAverageNamci, '.')
plot(namcidates, namciDenoised)
ylim([6 10])
datetick('x', 12)
title('naMCI TST Denoised')

sept1 = datenum([2015 9 1 0 0 0]);
sept30 = datenum([2015 9 30 0 0 0]);
dec1 = datenum([2015 12 1 0 0 0]);
dec30 = datenum([2015 12 30 0 0 0]);
apr1 = datenum([2016 4 1 0 0 0]);
apr30 = datenum([2016 4 30 0 0 0]);
july1 = datenum([2016 7 1 0 0 0]);
july30 = datenum([2016 7 30 0 0 0]);

septIntact = [];
septAmci = [];
septNamci = [];
for d = sept1:sept30
    thisday = find(intactdate == d);
    septIntact = [septIntact mean(intactTST(thisday), 'omitnan')];
    thisday = find(amcidate == d);
    septAmci = [septAmci mean(amciTST(thisday), 'omitnan')];
    thisday = find(namcidate == d);
    septNamci = [septNamci mean(namciTST(thisday), 'omitnan')];
end

disp(['Intact Sept: ' num2str(mean(septIntact)) ' +/- ' num2str(std(septIntact))])
disp(['aMCI Sept: ' num2str(mean(septAmci)) ' +/- ' num2str(std(septAmci))])
disp(['naMCI Sept: ' num2str(mean(septNamci)) ' +/- ' num2str(std(septNamci))])

decIntact = [];
decAmci = [];
decNamci = [];
for d = dec1:dec30
    thisday = find(intactdate == d);
    decIntact = [decIntact mean(intactTST(thisday), 'omitnan')];
    thisday = find(amcidate == d);
    decAmci = [decAmci mean(amciTST(thisday), 'omitnan')];
    thisday = find(namcidate == d);
    decNamci = [decNamci mean(namciTST(thisday), 'omitnan')];
end
disp(['Intact Dec: ' num2str(mean(decIntact)) ' +/- ' num2str(std(decIntact))])
disp(['aMCI Dec: ' num2str(mean(decAmci)) ' +/- ' num2str(std(decAmci))])
disp(['naMCI Dec: ' num2str(mean(decNamci)) ' +/- ' num2str(std(decNamci))])

aprIntact = [];
aprAmci = [];
aprNamci = [];
for d = apr1:apr30
    thisday = find(intactdate == d);
    aprIntact = [aprIntact mean(intactTST(thisday), 'omitnan')];
    thisday = find(amcidate == d);
    aprAmci = [aprAmci mean(amciTST(thisday), 'omitnan')];
    thisday = find(namcidate == d);
    aprNamci = [aprNamci mean(namciTST(thisday), 'omitnan')];
end
disp(['Intact Apr: ' num2str(mean(aprIntact)) ' +/- ' num2str(std(aprIntact))])
disp(['aMCI Apr: ' num2str(mean(aprAmci)) ' +/- ' num2str(std(aprAmci))])
disp(['naMCI Apr: ' num2str(mean(aprNamci)) ' +/- ' num2str(std(aprNamci))])

julyIntact = [];
julyAmci = [];
julyNamci = [];
for d = july1:july30
    thisday = find(intactdate == d);
    julyIntact = [julyIntact mean(intactTST(thisday), 'omitnan')];
    thisday = find(amcidate == d);
    julyAmci = [julyAmci mean(amciTST(thisday), 'omitnan')];
    thisday = find(namcidate == d);
    julyNamci = [julyNamci mean(namciTST(thisday), 'omitnan')];
end
disp(['Intact July: ' num2str(mean(julyIntact)) ' +/- ' num2str(std(julyIntact))])
disp(['aMCI July: ' num2str(mean(julyAmci)) ' +/- ' num2str(std(julyAmci))])
disp(['naMCI July: ' num2str(mean(julyNamci)) ' +/- ' num2str(std(julyNamci))])

figure
spectrogram(dailyAverageAmci)
title('Spectrogram for Amnestic MCI TST')

figure
spectrogram(dailyAverageIntact)
title('Spectrogram for Intact TST')

figure
spectrogram(dailyAverageNamci)
title('Spectrogram for Namci TST')

figure
autocorr(dailyAverageIntact,400)
title('Autocorrelation for Intact TST')

figure
autocorr(dailyAverageNamci,400)
title('Autocorrelation for naMCI TST')

figure
autocorr(dailyAverageAmci,400)
title('Autocorrelation for aMCI TST')
