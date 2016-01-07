
function [features, info] = featureMapFromFilesAugmented(directory)
% featureMapFromFilesAugmented Return a matrix of feature vectors loaded 
% from filesPath. Those files were previously generated using OverFeat.
% Input: directory = string where all the files are stored
% Output: features = matrix where each row is a feature vector
%         info = a struct with information about the features

    % Get only the names of the folders within the directory
    info.names = filterFolderNames(dir(directory));    
    
    % Initialize the array where we will store the number of features per
    % folder
    info.numFeatures = zeros(size(info.names));

    % Array list of features
    features = [];
    
    % For each subfolder in directory
    for i = 1 : length(info.names)
        
        % New folder
        subfolder = strcat(directory, filesep, info.names{i});
        
        % Get all file names
        allFiles = dir(subfolder);
        % Get only the names of the files inside the folder
        featureNames = cell({allFiles.name});
        featureNames = filterFileNames(featureNames, 'features'); 
        
        % Recover the number of features within the folder
        info.numFeatures(i) = length(featureNames);
        
        % Extract features from the first image
        [firstFeatures, stride] = featureMapFromFile(strcat(subfolder, filesep, featureNames{1}));

        % Initialize the feature matrix
        if (~stride)
            sub_features = zeros(length(featureNames),length(firstFeatures));
            sub_features(1,:) = firstFeatures;
        end
        
        % For each file
        for j= 2 : length(featureNames)
            ithFeature = featureMapFromFile(strcat(subfolder, filesep, featureNames{j}));
            sub_features(j,:) = ithFeature;
        end
        
        % Concatenate the new features
        features = vertcat(features, sub_features);
        
    end
    
end