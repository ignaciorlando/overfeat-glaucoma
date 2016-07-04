
config_downsample_set;

for d = 1 : length(sourcePaths)

    % Path where the images are saved
    imagePath = sourcePaths{d};
    outputPath = outputPaths{d};

    % Retrieve the names of the files in the folder
    imageNames = getMultipleImagesFileNames(imagePath);
    
    % For each image
    for i = 1 : length(imageNames)   
        fprintf('%d/%d\n',i,length(imageNames));
        % Generate image filename
        filename = strcat(imagePath, filesep, imageNames{i});
        % Get the extension
        [pathstr, name, ext] = fileparts(filename);
        % Open image
        I = imread(filename);    
        % Resize the images
        I = imresize(I, scale);
        if length(unique(I(:)))==2
            I = I > 0;
        end
        % Generate the new image filename
        filename = strcat(outputPath, filesep, imageNames{i});
        if strcmp(ext, '.jpg') || strcmp(ext, '.jpeg')
            filename = strcat(filename, '.png');
        end
        % Save the image
        imwrite( I, filename );
    end
    
end