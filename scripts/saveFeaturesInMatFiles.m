
root_features = 'C:\SharedFolderWithUbuntu';
root_output = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data';
% Types of images
%imageTypes = {'down', 'fov-crop-down', 'od-down', 'only-od-down'};
imageTypes = {'fov-crop-down'};
%augTypes = {'', '-aug-90', '-aug'};
augTypes = {'-aug'};
%shapes = {'rectangle','square','clahe'};
shapes = {'green', 'green-clahe'};
dataset = 'Drishti';
vesselState = 'original';
%vesselState = 'vesselInpainted';
%vesselState = 'vessels';


for s = 1 : length(shapes)

    for a = 1 : length(augTypes)

        augType = augTypes{a};
        shape = shapes{s};
        
        % Path where the features are stored
        if (strcmp(vesselState,'vesselInpainted'))
            rootPath = strcat(root_features,filesep, dataset, '-VI', filesep, shape);
        elseif (strcmp(vesselState,'vessels'))
            rootPath = strcat(root_features,filesep, dataset, '-Vessels', filesep, shape);
        else
            rootPath = strcat(root_features,filesep, dataset, filesep, shape);
        end
        % Path where the .mat files will be saved
        outputPath = strcat(root_output, filesep, dataset, filesep, 'features', filesep, vesselState, filesep, shape);

        % For each image type
        for i = 1 : length(imageTypes)

            if (strcmp(augType,''))
                
                % retrieve features
                [features] = featureMapFromFiles(strcat(rootPath, filesep, 'feat-', imageTypes{i}));
                
            else
                
                % Organize features in folders
                organizeFeaturesInFolder(strcat(rootPath, filesep, 'feat-', imageTypes{i}, augType), 'png');

                % Reorganize features
                [features, info] = featureMapFromFilesAugmented(strcat(rootPath, filesep, 'feat-', imageTypes{i}, augType));

            end
                
            % Save the reorganized features
            if (exist(strcat(outputPath, filesep, imageTypes{i}, augType),'dir')==0)
                mkdir(strcat(outputPath, filesep, imageTypes{i}, augType, filesep));
            end
            
            if (strcmp(augType,''))
                save(strcat(outputPath, filesep, imageTypes{i}, augType, filesep, 'feat-', imageTypes{i}, augType, '.mat'), 'features');
            else
                save(strcat(outputPath, filesep, imageTypes{i}, augType, filesep, 'feat-', imageTypes{i}, augType, '.mat'), 'features', 'info');
            end
                
        end
        
    end

end