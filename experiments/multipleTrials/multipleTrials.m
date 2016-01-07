

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

if (~isfield(options, 'numTrials'))
    options.numTrials = 1000;
    disp(strcat('The number of trials to be run was not previously set. I set by default ', num2str(options.numTrials)));
end
disp(strcat('Generating ', num2str(options.numTrials), ' random splits'));
randomizeOrderings = cell(options.numTrials,1);
for i = 1 : options.numTrials
    randomizeOrderings{i} = crossValidationSplits(size(features,1), 1);
end

%% Experiment

results.scores = [];
results.byFold.qualities = zeros(options.numTrials, 1);

% For each split
for k = 1 : options.numTrials
    
    % Display the number of split
    fprintf('\n\n======== Processing split number %d ========\n', k);
    
    % Retrieve the current split
    currentSplit = randomizeOrderings{k};
    
    % Training data
    [trainingdata] = generateStructOfData(currentSplit.trainingIndices, features, labels);
    % Validation data
    [validationdata] = generateStructOfData(currentSplit.validationIndices, features, labels);
    % Test data
    [testdata] = generateStructOfData(currentSplit.testIndices, features, labels);
    
    % Set the hyperparameters lambda and k according to the validation set
    [sub_results, results.searches(:,:,k)] = estimateHyperParametersByGridSearch(trainingdata, validationdata, options);
    
    % Learn the k-support regularized logistic regression model based on the parameters
    fprintf('Learning k-support regularized logistic regression using k=%d and lambda=%d\n', sub_results.model.k, sub_results.model.lambda);
    [model.w, model.costs] = ksupLogisticRegression(trainingdata.features, trainingdata.labels, sub_results.model.lambda, sub_results.model.k);

    % Evaluate on the test set
    disp('Evaluating on the test set');
    % Compute the scores
    currentScores = model.w' * testdata.features';
    % Evaluate using the performance measure as indicated in options
    results.byFold.qualities(k) = evaluateResults(testdata.labels, currentScores, options.measure);   
    % Save all the probabilities
    results.scores = [results.scores, currentScores];
    
end

%% Evaluate the quality using the ROC curve

% Display the number of split
fprintf('======== Experiments finished! ========\n');

% Mean area under the ROC curve
results.mean_auc = mean(results.byFold.qualities(:));
fprintf('Average AUC = %d', results.mean_auc);

%% Save the results

save(strcat(saveResultsPath, filesep, 'results.mat'), 'results', 'splits', 'sorting');
savefig(strcat(saveResultsPath, filesep, 'rocCurve.fig'));