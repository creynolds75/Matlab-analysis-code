%% This function finds time periods in the Actvite watch data where it is 
% likely the watch is not being worn
% Input: the threshold time in seconds for how long the watch must be 
% inactive to be considered off the wrist
% Output: nonactivetimestamps - Matlab datenums for the start of each 
% non-active period
% nonactivedurations: how long each nonactive period lasts in seconds

function [nonactivetimestamps, nonactivedurations] = findNonActiveActivite(nonactivethreshold)

% Load an Activite CSV file
[dt, durations, sleepState, steps] = loadActiviteData;

% Look for long durations with zero steps during times not 
% marked as sleep

% We will collect the indices of all non-active time periods
i = [];
% Set a threshold for how long the watch must be inactive to
% count as not being worn

% Loop through all the data and look for all cases where there are no steps
% and sleep is not detected for a greater time period than our threshold
for n = 1 : length(dt)
    if steps(n) == 0 & sleepState(n) == 0 & durations(n) > nonactivethreshold
        i = [i n];
    end
end
% Collect the nonactive time stamps and durations
nonactivetimestamps = dt(i);
nonactivedurations = durations(i);