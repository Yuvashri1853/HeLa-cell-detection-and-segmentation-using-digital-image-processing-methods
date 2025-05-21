%{
 Read CSV file
close all;
data = readtable('yuvatruth_new.csv'); % Replace with your actual filename

% Extract required columns
x = 1:height(data); % Assuming rows as X-axis points
y1 = data.NPR_Index_Paper;
y2 = data.NPR_Index_Our;

% Apply smoothing for trend lines
y1_smooth = smoothdata(y1, 'movmean', 10);
y2_smooth = smoothdata(y2, 'movmean', 10);

% Plot results
figure;
hold on;
grid on;

% Plot original data with different styles
plot(x, y1, 'r-.', 'LineWidth', 1.2); % Dashed red line (paper results)
plot(x, y1_smooth, 'r', 'LineWidth', 2.5); % Bold red (smoothed paper results)

plot(x, y2, 'c-.', 'LineWidth', 1.2); % Dashed cyan line (our results)
plot(x, y2_smooth, 'b', 'LineWidth', 3.5); % Bold blue (smoothed our results)

% Labels and title
title('NPR', 'FontSize', 10);
xlabel('Image Index');


% Legend
legend({'Results from ref paper. [16]', ...
        'Trend of results from ref paper. [16]', ...
        'Results from our proposal', ...
        'Trend of results from our proposal'}, ...
       'Location', 'SouthEast');

% Formatting
set(gca, 'FontSize', 8);
yticks(0.6:0.05:1);   % Set Y-axis ticks from 0.8 to 1 with a step of 0.02
ylim([0.6 1]);    % Set Y-axis scale to 0.1 intervals
%axis([min(x) max(x) 0 1]); % Set limits for better visualization
hold off;
%}
close all;
data = readtable('yuvatruth_new2.csv'); % Replace with your actual filename

% Extract required columns
x = 1:height(data); % Assuming rows as X-axis points
y1 = data.NPR_Index_Paper;
y2 = data.NPR_Index_Our;

% Apply smoothing for trend lines
y1_smooth = smoothdata(y1, 'movmean', 10);
y2_smooth = smoothdata(y2, 'movmean', 10);

% Plot results
figure;
hold on;
grid on;

% Plot original data with different styles
plot(x, y1, 'r-.', 'LineWidth', 1.2); % Dashed red line (paper results)
plot(x, y1_smooth, 'r', 'LineWidth', 2.5); % Bold red (smoothed paper results)

plot(x, y2, 'c-.', 'LineWidth', 1.2); % Dashed cyan line (our results)
plot(x, y2_smooth, 'b', 'LineWidth', 3.5); % Bold blue (smoothed our results)

% Labels and title
title('NPR', 'FontSize', 10);
xlabel('Image Index');


% Legend
legend({'Results from ref paper. [16]', ...
        'Trend of results from ref paper. [16]', ...
        'Results from our proposal', ...
        'Trend of results from our proposal'}, ...
       'Location', 'SouthWest');

% Formatting
set(gca, 'FontSize', 8);
yticks(0.95:0.1:1);   % Set Y-axis ticks from 0.8 to 1 with a step of 0.02
ylim([0.95 1]);    % Set Y-axis scale to 0.1 intervals
%axis([min(x) max(x) 0 1]); % Set limits for better visualization
hold off;