

%% Load features, indices and labels
disp('Loading features and labels');

% Load features
load(featuresFilePath);
% Load CDR features
load(featuresFilePathCDR);
% Load labels
load(labelsFilePath);

% Remove the variables indicating the paths
clear featuresFilePath labelsFilePath featuresFilePathCDR

%% Normalize the features and generate different trials by randomizing different orderings of the features

disp('Normalize features');
features = zscore(features);
if (size(cdrs, 2) > 1)
    cdrs = mean(cdrs, 2);
end
cdrs = zscore(cdrs);

% Reorganize features and labels into different cells
reorganizedFeatures = cell(size(labels));
reorganizedLabels = cell(size(labels));
for i = 1 : length(labels)
    % Take the first info.numFeatures(i) images
    newfeatures = zeros(size(features(1:info.numFeatures(i), :), 1), size(features(1:info.numFeatures(i), :), 2)+1);
    newfeatures(:,1:end-1) = features(1:info.numFeatures(i), :);
    newfeatures(:,end) =  ones(info.numFeatures(i),1) * cdrs(i); 
    reorganizedFeatures{i} = newfeatures;
    % Remove them from the feature list
    features(1:info.numFeatures(i), :) = [];
    % Copy info.numFeatures(i) labels to the cell array
    reorganizedLabels{i} = ones(info.numFeatures(i),1) * labels(i); 
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
