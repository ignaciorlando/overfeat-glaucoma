
function [features] = featureMapFromFiles(directory)
% featureMapFromFiles Return a matrix of feature vectors loaded from 
% filesPath. Those files were previously generated using OverFeat.
% Input: directory = string where all the files are stored
% Output: features = matrix where each row is a feature vector

    % Get all file names
    allFiles = dir(directory);
    % Get only the names of the files inside the folder
    allNames = cell({allFiles.name});
    allNames = filterFileNames(allNames, 'features');    

    % Extract features from the first image
    [firstFeatures, stride] = featureMapFromFile(strcat(directory, filesep, allNames{1}));
    
    % Initialize the feature matrix
    if (~stride)
        features = zeros(length(allNames),length(firstFeatures));
        features(1,:) = firstFeatures;
    end
    
    % For each file
    for i = 2 : length(allNames)
        ithFeature = featureMapFromFile(strcat(directory, filesep, allNames{i}));
        features(i,:) = ithFeature;
    end
    
end





