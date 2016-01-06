

%% Load features, indices and labels
disp('Loading features and labels');

% Load features
load(featuresFilePath);
% Load labels
load(labelsFilePath);
% Load sorting if it exists
if (exist(crossvalFilePath, 'file')==2)
    load(crossvalFilePath);
else
    sorting = [];
end

% Remove the variables indicating the paths
clear featuresFilePath labelsFilePath

%% Normalize all the features and organize them in different arrays

% Normalize the features
disp('Normalize features');
features = zscore(features);

% Reorganize features and labels into different cells
reorganizedFeatures = cell(size(labels));
reorganizedLabels = cell(size(labels));
for i = 1 : length(labels)
    % Take the first info.numFeatures(i) images
    reorganizedFeatures{i} = features(1:info.numFeatures(i), :);
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

%% Generate the splits

disp('Generate splits for cross validation');
if isempty(sorting)
    [splits, sorting] = crossValidationSplits(size(features,1), options.folds, sorting);
    save(crossvalFilePath, 'sorting', 'splits');
end

%% Experiment

results.scores = [];
results.labelsVals = [];
results.byFold.qualities = zeros(options.folds, 1);

% For each split
for k = 1 : options.folds
    
    % Display the number of split
    fprintf('\n\n======== Processing split number %d ========\n', k);
    
    % Retrieve the current split
    currentSplit = splits{k};
    
    % Training data
    [trainingdata] = generateStructOfData(currentSplit.trainingIndices, features, labels, 1);
    % Validation data
    [validationdata] = generateStructOfData(currentSplit.validationIndices, features, labels, 2);
    % Test data
    [testdata] = generateStructOfData(currentSplit.testIndices, features, labels, 2);
    
    % Set the hyperparameters lambda and k according to the validation set
    [sub_results] = estimateHyperParametersByGridSearch(trainingdata, validationdata, options);
    
    % Learn the k-support regularized logistic regression model based on the parameters
    fprintf('Learning k-support regularized logistic regression using k=%d and lambda=%d\n', sub_results.model.k, sub_results.model.lambda);
    [model.w, model.costs] = ksupLogisticRegression(trainingdata.features, trainingdata.labels, sub_results.model.lambda, sub_results.model.k);

    % Evaluate on the test set
    disp('Evaluating on the test set');

    % Compute the scores
    currentScores = model.w' * testdata.features';

    % Evaluate using the performance measure as indicated in options
    results.byFold.qualities(k) = evaluateResults(testdata.labels, currentScores, options.measure);
    
    % Save all the probabilities and the original labels
    results.scores = [results.scores, currentScores];
    results.labelsVals = [results.labelsVals, testdata.labels]; 
    
end

%% Evaluate the quality using the ROC curve

% Display the number of split
fprintf('======== Experiments finished! ========\n');

% Mean area under the ROC curve
results.mean_auc = mean(results.byFold.qualities(:));
fprintf('Average AUC = %d', results.mean_auc);

new_labels = [];
for i = 1 : length(labels)
    lbl = labels{i};
    new_labels = [new_labels, lbl(1)];
end

% Evaluate using the area under the ROC curve
[results.tpr, results.tnr, info] = vl_roc(2*new_labels-1, results.scores');
results.auc = info.auc;
fprintf('Test set ... AUC = %d\n', results.auc);

% Plot the ROC curve
figure, plot(1-results.tnr, results.tpr);
title('ROC curve');
xlabel('FPR (1 - Sensitivity)'); ylabel('TPR (Specificity)');

%% Save the results
if (exist(saveResultsPath,'dir')==0)
    mkdir(saveResultsPath);
end
save(strcat(saveResultsPath, filesep, 'results.mat'), 'results', 'splits', 'sorting');
savefig(strcat(saveResultsPath, filesep, 'rocCurve.fig'));