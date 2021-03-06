function [fitresult, gof] = createFitWeekly(weekStarts, weeklyMedianTST)
%CREATEFIT(WEEKSTARTS,WEEKLYMEDIANTST)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : weekStarts
%      Y Output: weeklyMedianTST
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 07-Oct-2016 10:11:56


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( weekStarts, weeklyMedianTST );

% Set up fittype and options.
ft = fittype( 'poly5' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'weeklyMedianTST vs. weekStarts', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel weekStarts
ylabel weeklyMedianTST
grid on


