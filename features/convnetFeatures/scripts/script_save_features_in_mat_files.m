
config_save_features_in_mat_files;

% For each preprocessing operation
for p = 1 : length(preprocessing)
    
    % Get the path where the features are saved
    'INPUT'
    rootPath = strcat(root_features, filesep, datasetname, filesep, preprocessing{p}, filesep, 'feat')
    % Path where the .mat files will be saved
    'OUTPUT'
    outputPath = strcat(root_output, filesep, datasetname, filesep, 'features',  filesep, cnn, '-', preprocessing{p})

    % Retrieve features
    [features] = featureMapFromFiles(strcat(rootPath));

    % Save the features
    if (exist(outputPath,'dir')==0)
        mkdir(outputPath);
    end
    save(strcat(outputPath, filesep, 'features.mat'), 'features');
    
end