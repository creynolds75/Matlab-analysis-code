function [fitresult, gof] = createFits(intactdates, dailyAverageIntact, namcidates, dailyAverageNamci, amcidates, dailyAverageAmci)
%CREATEFITS(INTACTDATES,DAILYAVERAGEINTACT,NAMCIDATES,DAILYAVERAGENAMCI,AMCIDATES,DAILYAVERAGEAMCI)
%  Create fits.
%
%  Data for 'untitled fit 1' fit:
%      X Input : intactdates
%      Y Output: dailyAverageIntact
%  Data for 'untitled fit 2' fit:
%      X Input : namcidates
%      Y Output: dailyAverageNamci
%  Data for 'untitled fit 3' fit:
%      X Input : amcidates
%      Y Output: dailyAverageAmci
%  Data for 'untitled fit 4' fit:
%      X Input : intactdates
%      Y Output: dailyAverageIntact
%  Data for 'untitled fit 5' fit:
%      X Input : amcidates
%      Y Output: dailyAverageAmci
%  Data for 'untitled fit 6' fit:
%      X Input : namcidates
%      Y Output: dailyAverageNamci
%  Output:
%      fitresult : a cell-array of fit objects representing the fits.
%      gof : structure array with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 22-Sep-2016 13:28:01

%% Initialization.

% Initialize arrays to store fits and goodness-of-fit.
fitresult = cell( 6, 1 );
gof = struct( 'sse', cell( 6, 1 ), ...
    'rsquare', [], 'dfe', [], 'adjrsquare', [], 'rmse', [] );

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( intactdates, dailyAverageIntact );

% Set up fittype and options.
ft = fittype( 'poly6' );

% Fit model to data.
[fitresult{1}, gof(1)] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult{1}, xData, yData );
legend( h, 'dailyAverageIntact vs. intactdates', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel intactdates
ylabel dailyAverageIntact
grid on

%% Fit: 'untitled fit 2'.
[xData, yData] = prepareCurveData( namcidates, dailyAverageNamci );

% Set up fittype and options.
ft = fittype( 'poly6' );

% Fit model to data.
[fitresult{2}, gof(2)] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 2' );
h = plot( fitresult{2}, xData, yData );
legend( h, 'dailyAverageNamci vs. namcidates', 'untitled fit 2', 'Location', 'NorthEast' );
% Label axes
xlabel namcidates
ylabel dailyAverageNamci
grid on

%% Fit: 'untitled fit 3'.
[xData, yData] = prepareCurveData( amcidates, dailyAverageAmci );

% Set up fittype and options.
ft = fittype( 'poly6' );

% Fit model to data.
[fitresult{3}, gof(3)] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 3' );
h = plot( fitresult{3}, xData, yData );
legend( h, 'dailyAverageAmci vs. amcidates', 'untitled fit 3', 'Location', 'NorthEast' );
% Label axes
xlabel amcidates
ylabel dailyAverageAmci
grid on
