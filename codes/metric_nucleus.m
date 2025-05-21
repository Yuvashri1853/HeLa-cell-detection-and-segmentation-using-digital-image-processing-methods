%% 
%% 
%{
close all;
% Define directories
gt_dir = 'nuclei500/';
paper_dir = 'basepaper_results/';
new_dir = 'paper_results/';
% Number of images
num_images = 300;
% Initialize arrays for storing metrics
metrics = zeros(num_images, 13); % 1 (image index) + 6 (paper) + 6 (our result)
% Loop over all images
for i = 1:num_images
% Create file names
file_gt = sprintf('%s%03d.tif', gt_dir, i);
file_paper = sprintf('%sNucleus_Result_%03d.tif', paper_dir, i);
file_new = sprintf('%sNucleus_Result_%03d.tif', new_dir, i);
% Read images
gt = imread(file_gt);
res_paper = imread(file_paper);
res_new = imread(file_new);
% Convert to grayscale if needed
if size(gt, 3) == 3
gt = rgb2gray(gt);
end
if size(res_paper, 3) == 3
res_paper = rgb2gray(res_paper);
end
if size(res_new, 3) == 3
res_new = rgb2gray(res_new);
end
% Resize images to match the ground truth
res_paper = imresize(res_paper, size(gt));
res_new = imresize(res_new, size(gt));
% Convert images to double before binarization
gt = im2double(gt);
res_paper = im2double(res_paper);
res_new = im2double(res_new);
% Convert images to binary
gt_bin = imbinarize(gt);
res_paper_bin = imbinarize(res_paper);
res_new_bin = imbinarize(res_new);
% Compute metrics
[P_paper, R_paper, F1_paper, D_paper, J_paper, NPR_paper] = compute_metrics(gt_bin, res_paper_bin);
[P_new, R_new, F1_new, D_new, J_new, NPR_new] = compute_metrics(gt_bin, res_new_bin);
% Store metrics in an array
metrics(i, :) = [i, P_paper, R_paper, F1_paper, D_paper, J_paper, NPR_paper, ...
P_new, R_new, F1_new, D_new, J_new, NPR_new];
end
% Convert data to table for saving
headers = {'Image_Index', 'Precision_Paper', 'Recall_Paper', 'F1_Score_Paper', 'Dice_Paper', 'Jaccard_Paper', 'NPR_Index_Paper', ...
'Precision_Our', 'Recall_Our', 'F1_Score_Our', 'Dice_Our', 'Jaccard_Our', 'NPR_Index_Our'};
% Convert to table
results_table = array2table(metrics, 'VariableNames', headers);
% Save individual image results to CSV
writetable(results_table, 'yuvatruth_new2.csv');
fprintf('Results saved successfully!\n');
% Compute median, mean, and standard deviation for required metrics
metrics_paper = metrics(:, [4, 5, 6, 7]); % F1_Paper, Dice_Paper, Jaccard_Paper, NPR_Paper
metrics_new = metrics(:, [10, 11, 12, 13]); % F1_Our, Dice_Our, Jaccard_Our, NPR_Our
% Compute and display results
metric_names = {'F1 Score', 'Dice Similarity Index', 'Jaccard Index', 'NPR Index'};
fprintf('\n--- Summary Statistics ---\n');
for j = 1:4
fprintf('\nMetric: %s\n', metric_names{j});
fprintf('Paper Result -> Mean: %.4f, Median: %.4f, Std Dev: %.4f\n', ...
mean(metrics_paper(:, j)), median(metrics_paper(:, j)), std(metrics_paper(:, j)));
fprintf('Our Result -> Mean: %.4f, Median: %.4f, Std Dev: %.4f\n', ...
mean(metrics_new(:, j)), median(metrics_new(:, j)), std(metrics_new(:, j)));
end
fprintf('\n--- Analysis Complete ---\n');
% Function to compute metrics with NaN handling
function [Precision, Recall, F1_score, Dice, Jaccard, NPR_Index] = compute_metrics(gt_bin, res_bin)
TP = sum((gt_bin == 1) & (res_bin == 1), 'all'); % True Positives
FP = sum((gt_bin == 0) & (res_bin == 1), 'all'); % False Positives
FN = sum((gt_bin == 1) & (res_bin == 0), 'all'); % False Negatives
TN = sum((gt_bin == 0) & (res_bin == 0), 'all'); % True Negatives
% Compute metrics and handle NaN values
Precision = TP / (TP + FP);
if isnan(Precision), Precision = 1; end
Recall = TP / (TP + FN);
if isnan(Recall), Recall = 1; end
F1_score = (2 * Precision * Recall) / (Precision + Recall);
if isnan(F1_score), F1_score = 1; end
Dice = (2 * TP) / (2 * TP + FP + FN);
if isnan(Dice), Dice = 1; end
Jaccard = TP / (TP + FP + FN);
if isnan(Jaccard), Jaccard = 1; end
% Normalized Probabilistic Rand Index Calculation
N_total = TP + TN + FP + FN; % Total pixels
Rand_Index = (TP + TN) / N_total;
Expected_Rand = ((TP + FN) * (TP + FP) + (TN + FN) * (TN + FP)) / (N_total^2);
NPR_Index = (Rand_Index - Expected_Rand) / (1 - Expected_Rand);
if isnan(NPR_Index), NPR_Index = 1; end
end
%}
% Define directories
gt_dir = 'nuclei500/';
paper_dir = 'basepaper_results/';
new_dir = 'paper_results/';
% Number of images
num_images = 300;
metrics = zeros(num_images, 13); % 1 (image index) + 6 (paper) + 6 (our result)
for i = 1:num_images
    % Create file names
    file_gt = sprintf('%s%03d.tif', gt_dir, i);
    file_paper = sprintf('%sNucleus_Result_%03d.tif', paper_dir, i);
    file_new = sprintf('%sNucleus_Result_%03d.tif', new_dir, i);
    % Read images
    gt = imread(file_gt);
    res_paper = imread(file_paper);
    res_new = imread(file_new);
    % Convert to grayscale if needed
    if size(gt, 3) == 3
        gt = rgb2gray(gt);
    end
    if size(res_paper, 3) == 3
        res_paper = rgb2gray(res_paper);
    end
    if size(res_new, 3) == 3
        res_new = rgb2gray(res_new);
    end
    res_paper = imresize(res_paper, size(gt));
    res_new = imresize(res_new, size(gt));
    gt = im2double(gt);
    res_paper = im2double(res_paper);
    res_new = im2double(res_new);
    gt_bin = imbinarize(gt);
    res_paper_bin = imbinarize(res_paper);
    res_new_bin = imbinarize(res_new);
    [P_paper, R_paper, F1_paper, D_paper, J_paper, NPR_paper] = compute_metrics(gt_bin, res_paper_bin);
    [P_new, R_new, F1_new, D_new, J_new, NPR_new] = compute_metrics(gt_bin, res_new_bin);
    metrics(i, :) = [i, P_paper, R_paper, F1_paper, D_paper, J_paper, NPR_paper, ...
                     P_new, R_new, F1_new, D_new, J_new, NPR_new];
end
headers = {'Image_Index', 'Precision_Paper', 'Recall_Paper', 'F1_Score_Paper', 'Dice_Paper', 'Jaccard_Paper', 'NPR_Index_Paper', ...
           'Precision_Our', 'Recall_Our', 'F1_Score_Our', 'Dice_Our', 'Jaccard_Our', 'NPR_Index_Our'};
% Convert to table
results_table = array2table(metrics, 'VariableNames', headers);
% Save individual image results to CSV
writetable(results_table, 'cell_results.csv');
fprintf('Results saved successfully!\n');
% Compute statistics for required metrics
metrics_paper = metrics(:, [4, 5, 6, 7]); % F1_Paper, Dice_Paper, Jaccard_Paper, NPR_Paper
metrics_new = metrics(:, [10, 11, 12, 13]); % F1_Our, Dice_Our, Jaccard_Our, NPR_Our
metric_names = {'F1 Score', 'Dice Similarity Index', 'Jaccard Index', 'NPR Index'};
fprintf('\n--- Summary Statistics ---\n');
for j = 1:4
    fprintf('\nMetric: %s\n', metric_names{j});
    fprintf('Paper Result -> Mean: %.4f, Median: %.4f, Std Dev: %.4f\n', ...
            mean(metrics_paper(:, j)), median(metrics_paper(:, j)), std(metrics_paper(:, j)));
    fprintf('Our Result -> Mean: %.4f, Median: %.4f, Std Dev: %.4f\n', ...
            mean(metrics_new(:, j)), median(metrics_new(:, j)), std(metrics_new(:, j)));
    % Perform Z-test
    [~, p_value, ~, z_score] = ztest(metrics_new(:, j), mean(metrics_paper(:, j)), std(metrics_paper(:, j)));
    fprintf('Z-test Statistic: %.4f, P-value: %.4f\n', z_score, p_value);
    % Interpretation
    if p_value < 0.05
        fprintf('Significant difference found! Our method is statistically better than the paper.\n');
    else
        fprintf('No significant difference found. Both methods perform similarly.\n');
    end
end
fprintf('\n--- Analysis Complete ---\n');
% Function to compute metrics with NaN handling
function [Precision, Recall, F1_score, Dice, Jaccard, NPR_Index] = compute_metrics(gt_bin, res_bin)
    TP = sum((gt_bin == 1) & (res_bin == 1), 'all'); % True Positives
    FP = sum((gt_bin == 0) & (res_bin == 1), 'all'); % False Positives
    FN = sum((gt_bin == 1) & (res_bin == 0), 'all'); % False Negatives
    TN = sum((gt_bin == 0) & (res_bin == 0), 'all'); % True Negatives
    Precision = TP / (TP + FP); if isnan(Precision), Precision = 1; end
    Recall = TP / (TP + FN); if isnan(Recall), Recall = 1; end
    F1_score = (2 * Precision * Recall) / (Precision + Recall); if isnan(F1_score), F1_score = 1; end
    Dice = (2 * TP) / (2 * TP + FP + FN); if isnan(Dice), Dice = 1; end
    Jaccard = TP / (TP + FP + FN); if isnan(Jaccard), Jaccard = 1; end
    N_total = TP + TN + FP + FN; % Total pixels
    Rand_Index = (TP + TN) / N_total;
    Expected_Rand = ((TP + FN) * (TP + FP) + (TN + FN) * (TN + FP)) / (N_total^2);
    NPR_Index = (Rand_Index - Expected_Rand) / (1 - Expected_Rand);
    if isnan(NPR_Index), NPR_Index = 1; end
end
