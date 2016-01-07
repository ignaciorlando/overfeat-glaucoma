
function [outputImages, imgNames] = readBunchImages(imagesPath)
% readBunchImages This function opens a bunch of images on a given path.
% INPUT: imagesPath = string indicating where the images are stored.
% OUTPUT: outputImages = a cell-array with a list of images.
%         imgNames = list of image names.

    % Retrieve the names of the images
    imgNames = dir(imagesPath);

    % Create an array to save the images
    outputImages = cell(length(imgNames) - 2, 1);
    
    % For each of the images in the list
    for i = 3 : length(imgNames)
        
        % Read and store the image
        outputImages{i-2} = imread(strcat(imagesPath, filesep, imgNames(i).name));
        
    end
    
    % Remove the first 2 names in the array, corresponding to '.' and '..'
    imgNames = {imgNames.name};
    imgNames = imgNames(3:end);

end