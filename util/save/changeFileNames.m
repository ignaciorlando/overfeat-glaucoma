
filenamesRoot = '';
imageRoot = '';

% Retrieve the names of the images
imgNames = dir(filenamesRoot);
prevImg = dir(imageRoot);

% Create an array to save the images
outputImageNames = cell(length(imgNames) - 2, 1);
prevImageNames = cell(length(prevImg) - 2, 1);

% For each of the images in the list
for i = 3 : length(outputImageNames)

    % Read and store the image
    movefile(strcat(imageRoot, filesep, prevImageNames(i).name), strcat(imageRoot, filesep, outputImageNames(i).name));
    
end