
function organizeFeaturesInFolder(featuresPath, extension)
% organizeFeaturesInFolder Organizes the features files in featuresPath
% in separate folder.
% INPUT: featuresPath = path where the features are stored
%        extension = file extension of the original images.

    % Add a . to the extension
    extension = strcat('.', extension);

    % Retrieve the names of the files in the folder
    featureNames = dir(featuresPath);
    featureNames = {featureNames(~[featureNames.isdir]).name};
    idx = ~cellfun('isempty', regexp(featureNames,'.features'));
    featureNames = featureNames(idx);

    % For each feature file in the list
    for i = 1 : length(featureNames)

        % Retrieve folder name
        imageNameParts = strsplit(featureNames{i}, '_');
        folderName = strcat(imageNameParts{1}, '_', imageNameParts{2});

        % Generate the new folder path
        fullFolderPath = strcat(featuresPath,filesep,folderName);

        % If the folder doesnt exist, create new
        if ~exist(fullFolderPath, 'dir')
            % Create a new dir
            mkdir(fullFolderPath);
        end

        % Move the current file to the new folder
        movefile(strcat(featuresPath, filesep, featureNames{i}), strcat(fullFolderPath, filesep, featureNames{i}));

    end

end