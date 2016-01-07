

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

disp(strcat('Generating ', num2str(options.numTrials), ' random splits'));
randomizeOrderings = cell(options.numTrials,1);
for i = 1 : options.numTrials
    [fold.trainingIndices, fold.validationIndices, fold.testIndices] = generateSplits(size(features,1), options.trainingFraction, 1 - options.trainingFraction);
    randomizeOrderings{i} = fold;
end