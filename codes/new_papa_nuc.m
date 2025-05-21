function [nucleos] = dv_HeLaCellDetection(I,C)
IO = I;
I = imresize(I, [500 500]);
[u,v] = size(I);
Ig = imgaussfilt(I,.2);
J = stdfilt(Ig);
edges = edge(J, 'canny');
se = strel('disk', 2);
edges = imdilate(edges, se);
newShape = zeros(u,v);
for i=1:u
    for j=1:v
        if edges(i,j) == 255 || edges(i,j) == 1
            newShape(i,j) = 0;
        else 
            newShape(i,j) = 255;
        end
    end
end
bw = bwareaopen(newShape,300);
Res = imfill(bw,'holes');
CC = bwconncomp(Res, 4);
numPixels = cellfun(@numel, CC.PixelIdxList);
[tamx,tamy] = size(numPixels);
nucleos = zeros(u,v);
for k=1:tamy
    if numPixels(k) >= 400 && numPixels(k) < 40000
        nucleos(CC.PixelIdxList{k}) = 255;
    end
end
propNuc = nucleos;
rescell=C;
rescell = imresize(rescell, [500 500]);
nucleos = dv_checkNucinCell(rescell, nucleos);
nucleos = dv_checkRound(nucleos);
nucMay = nucleos; % Original image or matrix
nucleos = zeros(u,v); % Initialize matrix
CC_nuc = bwconncomp(nucMay); % Find connected components
numNucs = cellfun(@numel, CC_nuc.PixelIdxList); % Get areas of components
[x_n,y_n] = size(numNucs);
if y_n ~= 0
    valMax = max(max(numNucs));
    nucleos(CC_nuc.PixelIdxList{find(valMax)}) = 255;
end
nucleos = dv_closeNucleis(I, nucleos, rescell);
end
close all;
 %Define paths to the folders containing the input images
I_folder = 'Extracted_Slices/';
C_folder = '08_results_cells/';
output_folder = 'paper_results/'; % Folder to store the output images
if ~exist(output_folder, 'dir') % Check if the folder exists, create if not
    mkdir(output_folder);
end
% Loop through 300 images
for k = 1:300
    % Generate file names for the current image
    I_path = sprintf('%sSlice_%03d.tif', I_folder, k); % e.g., Slice_001.tif
    C_path = sprintf('%s%03d.png', C_folder, k); % e.g., Processed_GT_Slice_1.tif

    % Read the images
    I_image = imread(I_path);
    C_image = imread(C_path);
    % Perform nucleus detection using the dv_HeLaCellDetection function
    nucleus = dv_HeLaCellDetection(I_image, C_image);
    % Define the output path for the processed image
    output_path = sprintf('%sNucleus_Result_%03d.tif', output_folder, k); % Save as PNG file
    % Save the processed output as an image
    imwrite(nucleus, output_path);
    % Optionally display progress
    fprintf('Processed and saved image %d/300: %s\n', k, output_path);
end
% Inform the user
disp('Processing complete. Output images saved in the Results folder.');
