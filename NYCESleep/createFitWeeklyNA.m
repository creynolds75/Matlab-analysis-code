function [fitresult, gof] = createFitWeeklyNA(weekNamciStarts, weeklyMedianNamciTST)
%CREATEFIT(WEEKNAMCISTARTS,WEEKLYMEDIANNAMCITST)
%  Create a fit.
%
%  Data for 'untitled fit 2' fit:
%      X Input : weekNamciStarts
%      Y Output: weeklyMedianNamciTST
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 07-Oct-2016 11:22:59


%% Fit: 'untitled fit 2'.
[xData, yData] = prepareCurveData( weekNamciStarts, weeklyMedianNamciTST );

% Set up fittype and options.
ft = fittype( 'poly4' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 2' );
h = plot( fitresult, xData, yData );
legend( h, 'weeklyMedianNamciTST vs. weekNamciStarts', 'untitled fit 2', 'Location', 'NorthEast' );
% Label axes
xlabel weekNamciStarts
ylabel weeklyMedianNamciTST
grid on


