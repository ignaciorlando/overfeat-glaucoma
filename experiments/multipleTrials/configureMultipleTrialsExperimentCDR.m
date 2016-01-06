

%% Load features, indices and labels
disp('Loading features (including CDRs) and labels');

% Load features
load(featuresFilePath);
% Load CDR features
load(featuresFilePathCDR);
% Load labels
load(labelsFilePath);


newfeatures = zeros(size(features,1), size(features,2) + 1);
newfeatures(:, 1:end-1) = features;
% If there are more than just 1 cdr, compute the mean value;
if (size(cdrs, 2) > 1)
    cdrs = mean(cdrs, 2);
end
newfeatures(:, end) = cdrs;
features = newfeatures;

% Remove the variables indicating the paths
clear featuresFilePath labelsFilePath newfeatures featuresFilePathCDR

%% Normalize the features and generate different trials by randomizing different orderings of the features

disp('Normalize features');
features = zscore(features);

disp(strcat('Generating ', num2str(options.numTrials), ' random splits'));
randomizeOrderings = cell(options.numTrials,1);
for i = 1 : options.numTrials
    [fold.trainingIndices, fold.validationIndices, fold.testIndices] = generateSplits(size(features,1), options.trainingFraction, 1 - options.trainingFraction);
    randomizeOrderings{i} = fold;
end