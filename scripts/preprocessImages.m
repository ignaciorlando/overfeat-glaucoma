
% Types of images
imageTypes = {'im-down', 'im-fov-crop-down', 'im-od-down', 'im-only-od-down'};

% Preprocessing functions
preprocessingFunctions = {@clahePreprocessing};
preprocessingFunctionsNames = {'clahe'};

% Path where the images will be stored
rootPath = 'C:\SharedFolderWithUbuntu\Drishti';

% Create a single folder for each data set to output each preprocessed
% bunch of images
for i = 1 : length(preprocessingFunctionsNames)
    
    % For each image type
    for j = 1 : length(imageTypes)
        
        % Generate the new folder name and create it if it doesnt exist
        newFolderName = strcat(rootPath, filesep, imageTypes{j}, '-', preprocessingFunctionsNames{i}); 
        if (exist(newFolderName, 'dir')==0)
            mkdir(newFolderName);
        end
        
    end
    
end

% For each image type
for i = 1 : length(imageTypes)
    
    % Retrieve the names of the images
    imgNames = dir(strcat(rootPath, filesep, imageTypes{i}));
    
    % For each of the images in the list
    for j = 3 : length(imgNames)
        
        % Read the image
        I = imread(strcat(rootPath, filesep, imageTypes{i}, imgNames(i).name));
        
        % Generate the new image, with each band enhanced
        newI = uint8(zeros(size(I)));
        for k = 1 : size(I, 3)
            % Histogram equalization
            adapted = adapthisteq(I(:,:,k));
            % Return the values to the [0,255] interval
            newI(:,:,k) = uint8((adapted / max(adapted(:))) * 255);
        end
        
        % Save the image
        
        
        outputImages{i-2} = 
        
    end
    
    
end