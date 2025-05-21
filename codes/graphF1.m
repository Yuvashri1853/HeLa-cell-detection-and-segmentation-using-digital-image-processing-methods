%{
% Read CSV file
close all;
data = readtable('yuvatruth_new.csv'); % Replace with your actual filename

% Extract required columns
x = 1:height(data); % Assuming rows as X-axis points
y1 = data.F1_Score_Paper;
y2 = data.F1_Score_Our;

% Apply smoothing for trend lines
y1_smooth = smoothdata(y1, 'movmean', 10);
y2_smooth = smoothdata(y2, 'movmean', 10);

% Plot result
figure;
hold on;
grid on;

% Plot original data with different styles
plot(x, y1, 'r-.', 'LineWidth', 0.75); % Dashed red line (paper results)
plot(x, y1_smooth, 'r', 'LineWidth', 2.0); % Bold red (smoothed paper results)

plot(x, y2, 'c-.', 'LineWidth', 1.0); % Dashed cyan line (our results)
plot(x, y2_smooth, 'b', 'LineWidth', 3.0); % Bold blue (smoothed our results)

% Labels and title
title('F1 Score', 'FontSize', 10);
xlabel('Image Index');


% Legend
legend({'Results from ref paper. [16]', ...
        'Trend of results from ref paper. [16]', ...
        'Results from our proposal', ...
        'Trend of results from our proposal'}, ...
       'Location', 'SouthEast');

% Formatting
set(gca, 'FontSize', 8);
xticks(0:50:max(x));  % Set X-axis scale to 50 intervals
yticks(0.8:0.02:1);   % Set Y-axis ticks from 0.8 to 1 with a step of 0.02
ylim([0.8 1]);     
hold off;
%}
% Read CSV file
close all;
data = readtable('yuvatruth_new2.csv'); % Replace with your actual filename

% Extract required columns
x = 1:height(data); % Assuming rows as X-axis points
y1 = data.F1_Score_Paper;
y2 = data.F1_Score_Our;

% Apply smoothing for trend lines
y1_smooth = smoothdata(y1, 'movmean', 10);
y2_smooth = smoothdata(y2, 'movmean', 10);

% Plot result
figure;
hold on;
grid on;

% Plot original data with different styles
plot(x, y1, 'r-.', 'LineWidth', 0.75); % Dashed red line (paper results)
plot(x, y1_smooth, 'r', 'LineWidth', 2.0); % Bold red (smoothed paper results)

plot(x, y2, 'c-.', 'LineWidth', 1.0); % Dashed cyan line (our results)
plot(x, y2_smooth, 'b', 'LineWidth', 3.0); % Bold blue (smoothed our results)

% Labels and title
title('F1 Score', 'FontSize', 10);
xlabel('Image Index');


% Legend
legend({'Results from ref paper. [16]', ...
        'Trend of results from ref paper. [16]', ...
        'Results from our proposal', ...
        'Trend of results from our proposal'}, ...
       'Location', 'SouthWest');

% Formatting
set(gca, 'FontSize', 8);
xticks(0:50:max(x));  % Set X-axis scale to 50 intervals
yticks(0.95:0.01:1);   % Set Y-axis ticks from 0.8 to 1 with a step of 0.02
ylim([0.95 1]);     
hold off;

