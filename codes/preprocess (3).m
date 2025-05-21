function processHeLaCells(inputDir, outputDir)
    % Get a list of all image files in the input directory
    imageFiles = dir(fullfile(inputDir, '*.tif'));
    % Create output directory if it doesn’t exist
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    % Loop through each image
    for k = 1:length(imageFiles)
        % Read the image
        imagePath = fullfile(inputDir, imageFiles(k).name);
        img = imread(imagePath);
        img = mat2gray(img); % Normalize image
        % Apply Gaussian smoothing with kernel size 7x7 and standard deviation 2
        h = fspecial('gaussian', [7 7], 2);
        lowPassFiltered = imfilter(img, h, 'symmetric');
        % Threshold to capture high-intensity regions (like nucleus)
        highIntensityMask = lowPassFiltered > 0.75;
        % Morphological closing with a larger structuring element
        se = strel('disk', 10); % Larger disk size to close gaps
        closedMask = imclose(highIntensityMask, se);
        % Fill holes
        %filledMask = imfill(closedMask, 'holes');
        minRegionSize = 50; % Adjust size as needed to keep desired regions
        cleanedMask = bwareaopen(closedMask, minRegionSize);
        %figure; imshow(cleanedMask); title('After Removing Small Regions');% Remove small noise and objects
        %cleanedMask = bwareaopen(filledMask, 30);
        % Create the final display image: background gray (0.7), foreground white (1)
        displayImage = 0.7 * ones(size(cleanedMask));
        displayImage(cleanedMask) = 1;
        % Save the result
        outputFile = fullfile(outputDir, ['Processed_' imageFiles(k).name]);
        imwrite(displayImage, outputFile);
        % Show progress
        fprintf('Processed and saved: %s\n', outputFile);
    end
    fprintf('All images processed and saved in %s\n', outputDir);
end
% Define input and output directories
inputDir = 'Extracted_Slices';
outputDir = 'Preprocessed_SEM_Images';
% Process the images
processHeLaCells(inputDir, outputDir);
