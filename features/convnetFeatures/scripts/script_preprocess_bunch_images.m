 
config_preprocess_bunch_images;

% For each data set
for i = 1 : length(datasetsNames)
    
    % Get image path
    imagesPath = strcat(rootDatasets, filesep, datasetsNames{i}, filesep, 'images');
    masksPath = strcat(rootDatasets, filesep, datasetsNames{i}, filesep, 'masks');
    segmsPath = strcat(rootSegmentations, filesep, datasetsNames{i}, filesep, 'segmentations');
    % Get results path
    resultsPath = strcat(rootResults, filesep, datasetsNames{i});
    if (exist(resultsPath,'dir')==0)
        mkdir(resultsPath);
    end
    
    % Retrieve image names...
    imgNames = getMultipleImagesFileNames(imagesPath);
    % ...and mask names
    mskNames = getMultipleImagesFileNames(masksPath);
    % ...and segms names
    segmsNames = getMultipleImagesFileNames(segmsPath);
    
    % For each image, process it
    for j = 1 : length(imgNames)
        j
        % open the image
        I = imread(strcat(imagesPath, filesep, imgNames{j}));
        % open the mask
        mask = imread(strcat(masksPath, filesep, mskNames{j})) > 0;
        mask = mask(:,:,1);
        % open the segmentation
        segm = imread(strcat(segmsPath, filesep, segmsNames{j})) > 0;
        segm = segm(:,:,1);
        
        % if the images has to cropped
        if (crop_images)
            % get crop FOV of the image
            [I, ~] = cropFOV(I, mask);
            % get crop FOV of the segmentation and mask
            [segm, mask] = cropFOV(segm, mask);
        end
        
        % for each preprocessing technique
        for k = 1 : length(preprocessings_names)

            if (preprocessings_methods(k))
                % create folder
                filename_path = strcat(resultsPath, filesep, preprocessings_names{k}, filesep, 'im');
                if (exist(filename_path,'dir')==0)
                    mkdir(filename_path);
                end

                % preprocess the image
                switch k
                    case 1 % color
                        outputImage = I;
                    case 2 % color + inp
                        outputImage = imageInpainting(I, segm);
                    case 3 % green
                        outputImage = I(:,:,2);
                    case 4 % green + inp
                        outputImage = imageInpainting(I(:,:,2), segm);
                    case 5 % norm-color
                        outputImage = colorEqualization(I, mask);
                    case 6 % norm-color-inp
                        outputImage = colorEqualization(imageInpainting(I, segm), mask);
                    case 7 % clahe on color image
                        outputImage = adapthisteqCOLOR(I);
                    case 8 % clahe on color image without vessel
                        outputImage = adapthisteqCOLOR(imageInpainting(I, segm));
                    case 9 % clahe on green image
                        outputImage = adapthisteq(I(:,:,2));
                    case 10 % clahe on green image without vessel
                        outputImage = adapthisteq(imageInpainting(I(:,:,2), segm));
                    otherwise
                        disp('it is impossible to enter here');
                end

                % save the image
                imwrite(outputImage, strcat(filename_path, filesep, imgNames{j}));
            end
            
        end
        
    end
    
end