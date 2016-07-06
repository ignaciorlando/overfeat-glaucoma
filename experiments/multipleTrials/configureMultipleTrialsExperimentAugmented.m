

%% Load features, indices and labels
disp('Loading features and labels');

% Load features
load(featuresFilePath);
% Load labels
load(labelsFilePath);

% Remove the variables indicating the paths
clear featuresFilePath labelsFilePath

%% Normalize the features and generate different trials by randomizing different orderings of the features

disp('Normalize features');
features = zscore(features);

% Reorganize features and labels into different cells
reorganizedFeatures = cell(size(labels));
reorganizedLabels = cell(size(labels));
for i = 1 : length(labels)
    % Take the first info.numFeatures(i) images
    reorganizedFeatures{i} = features(1:info.numFeatures(1), :);
    % Remove them from the feature list
    features(1:info.numFeatures(1), :) = [];
    % Copy info.numFeatures(i) labels to the cell array
    reorganizedLabels{i} = ones(info.numFeatures(1),1) * labels(i); 
end
% Reassign the reorganized features and labels
features = reorganizedFeatures;
labels = reorganizedLabels;

% Remove the temporal variable
clear reorganizedFeatures reorganizedLabels

disp(strcat('Generating ', num2str(options.numTrials), ' random splits'));
randomizeOrderings = cell(options.numTrials,1);
for i = 1 : options.numTrials
    [fold.trainingIndices, fold.validationIndices, fold.testIndices] = generateSplits(size(features,1), options.trainingFraction, 1 - options.trainingFraction);
    randomizeOrderings{i} = fold;
end
