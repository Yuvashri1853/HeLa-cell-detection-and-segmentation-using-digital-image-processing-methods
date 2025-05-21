clc; clear; close all;
% Define input and output directories
inputDir = 'Preprocessed_SEM_Images'; % Folder containing 300 images
outputDir = 'Segmented_Cell_Results'; % Folder to save processed images
outputDir1 = 'InterProcessed_Output';
% Create output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
% Get list of all images in the dataset
imageFiles = dir(fullfile(inputDir, '*.tif'));
% Process each image in the dataset
for idx = 1:min(300, length(imageFiles)) % Limit to 300 images
    % Read the image
    originalImage = imread(fullfile(inputDir, imageFiles(idx).name));
    if size(originalImage, 3) == 3
        grayscaleImage = rgb2gray(originalImage); % Convert to grayscale if RGB
    else
        grayscaleImage = originalImage;
    end
    % Enhance contrast
    enhancedImage = imadjust(grayscaleImage);
    % Thresholding to segment the cells
    thresholdLevel = graythresh(enhancedImage);
    binaryImage = imbinarize(enhancedImage, thresholdLevel);
    binaryImage = ~binaryImage; % Invert to make cells white
    % Distance transform and Watershed Algorithm
    D = -bwdist(~binaryImage);
    D = imhmin(D, 20);
    L = watershed(D);
    watershedImage = binaryImage;
    watershedImage(L == 0) = 0;
    % Remove small objects
    minRegionArea = 20;
    cleanedImage = bwareaopen(watershedImage, minRegionArea);
    % Identify the largest region near the center
    stats = regionprops(cleanedImage, 'Centroid', 'Area', 'PixelIdxList');
    imageCenter = size(cleanedImage) / 2;
    largestArea = 0;
    centralRegion = [];
    for i = 1:length(stats)
        centroid = stats(i).Centroid;
        distance = sqrt((centroid(1) - imageCenter(1))^2 + (centroid(2) - imageCenter(2))^2);
        if distance < 0.2 * max(size(cleanedImage)) && stats(i).Area > largestArea
            largestArea = stats(i).Area;
            centralRegion = stats(i);
        end
    end
    % Create a mask for the largest region
    finalMask = false(size(cleanedImage));
    if ~isempty(centralRegion)
        finalMask(centralRegion.PixelIdxList) = 1;
    else
        disp('No central region found.');
    end
    % Erosion
    erodedCell = imerode(finalMask, strel('disk', 1));
    outputFileName = fullfile(outputDir1, ['Processed_' imageFiles(idx).name]);
    imwrite(erodedCell, outputFileName);
    % Find and thicken boundaries
    boundaries = bwperim(erodedCell);
    thickBoundaries = imdilate(boundaries, strel('disk', 3));
    outlinedImage = zeros(size(erodedCell));
    outlinedImage(thickBoundaries) = 1;
    %figure;imshow(outlinedImage);
    % Edge detection and binarization
    edges = edge(originalImage, 'Sobel');
    edges = imdilate(edges, strel('disk', 3));
    sum_edges = edges + outlinedImage;
    binary_from_a = imbinarize(sum_edges);
    % Hole filling
    filled_holes = imfill(binary_from_a, 'holes');
    % Select the largest object from the filled_holes image
    stats_filled = regionprops(filled_holes, 'Area', 'PixelIdxList');
    if ~isempty(stats_filled)
        [~, largestIndex_filled] = max([stats_filled.Area]);
        largestRegion_filled = stats_filled(largestIndex_filled);
        largestObjectMask_filled = zeros(size(filled_holes));
        largestObjectMask_filled(largestRegion_filled.PixelIdxList) = 1;
        finalMask = largestObjectMask_filled & binaryImage;
    else
        disp('No large object detected in the filled_holes image.');
    end
    lower_limit = 50;
    upper_limit = 200;
    limited_pixels = finalMask;
    limited_pixels(finalMask < lower_limit | finalMask > upper_limit) = 0;
    % Hole-filling and small/large object removal
    filled_final = imfill(limited_pixels, 'holes');
    small_obj_removed = bwareaopen(filled_final, 50);
    large_obj_removed = xor(small_obj_removed, bwareaopen(small_obj_removed, 5000));
    % Invert binary image
    invertedBinaryImage = finalMask;
    % Apply erosion
    erodedImage = imerode(invertedBinaryImage, strel('disk', 3));
    % Apply dilation
    dilatedImage = imdilate(erodedImage, strel('disk', 3));
    dilatedImage1 = bwareaopen(dilatedImage, 300);
    stats = regionprops(dilatedImage1, 'Area', 'PixelIdxList');
    % Identify the largest object
    if ~isempty(stats)
        [~, largestIndex] = max([stats.Area]); % Find the index of the largest area
        largestObjectMask = false(size(dilatedImage1));
        largestObjectMask(stats(largestIndex).PixelIdxList) = 1; % Create mask for the largest object
    else
        %disp('No objects found in the image.');
        largestObjectMask = false(size(dilatedImage1)); % Return an empty mask
    end
    % Perform hole filling
    filledImage = imfill(largestObjectMask, 'holes'); 
    % Save the processed image
    outputFileName = fullfile(outputDir, ['Processed_' imageFiles(idx).name]);
    imwrite(filledImage, outputFileName);
    fprintf('Processed and saved: %s\n', outputFileName);
end
fprintf('Processing complete. Processed images are saved in: %s\n', outputDir);