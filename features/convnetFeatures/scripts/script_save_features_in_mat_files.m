
config_save_features_in_mat_files;

% For each preprocessing operation
for p = 1 : length(preprocessing)
    
    % For each crop
    for c = 1 : length(crops)

        % For each augmentation strategy
        for a = 1 : length(augmentations)
    
            % Get the path where the features are saved
            'INPUT'
            rootPath = fullfile(root_features, datasetname, preprocessing{p}, strcat(crops{c}, augmentations{a}), 'feat')
            % Path where the .mat files will be saved
            'OUTPUT'
            outputPath = fullfile(root_output, datasetname, 'features', preprocessing{p}, strcat(crops{c}, augmentations{a}), cnn)

            % Retrieve features
            if (strcmp(augmentations{a}, ''))
                [features, info] = featureMapFromFiles(rootPath);
            else
                [features, info] = featureMapFromFilesAugmented(rootPath);
            end

            % Save the features
            if (exist(outputPath,'dir')==0)
                mkdir(outputPath);
            end
            save(strcat(outputPath, filesep, 'features.mat'), 'features', 'info');
    
        end
    
    end
    
end