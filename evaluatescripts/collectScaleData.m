dirname = 'C:\Users\dunch\Documents\MATLAB\evaluate\scaleDataFeb8';
listing = dir(dirname);

for n = 3 : length(listing)
    filename = listing(n).name
    M = csvread(fullfile(dirname,filename))
end

