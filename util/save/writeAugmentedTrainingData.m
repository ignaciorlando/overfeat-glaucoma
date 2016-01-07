
function writeAugmentedTrainingData(path, images, imageNames, separated)
% writeAugmentedTrainingData This function writes  a bunch of images on a 
% given path. Each transformation is save within a separate folder.
% INPUT: path = string indicating where the images will be stored.
%        images = cell array of images with the augmented training set.
%        imageNames = cell array with the names of the images
%        separated = a boolean indicating if each file has to be stored in
%           a single folder.

    % Retrieve the original extension
    [~, extension] = strtok(imageNames{1}, '.');

    % Remove extensions
    for i = 1 : length(imageNames)
        imageNames{i} = strtok(imageNames{i}, '.');
    end

    % For each image on the cell array
    for i = 1 : length(images)
        
        % If images corresponding to the same original image  has to be 
        % stored within a folder
        if (separated) 
            
            % Generate the name of the new folder
            currentDir = strcat(path, filesep, imageNames{i});
            % Create the new folder
            mkdir(currentDir);
            
        else
            
            % Generate the name of the current folder
            currentDir = path;
        
        end

        % Retrieve the transformed images
        transformed = images{i};

        % For each transformed image
        for j = 1 : length(transformed)

            newName = strcat(currentDir, filesep, imageNames{i}, '_', num2str(j), extension);

            % Save the image in the new folder
            imwrite(transformed{j}, newName);

        end
               
    end
    
end