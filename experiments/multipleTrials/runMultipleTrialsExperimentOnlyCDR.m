

%% Load features, indices and labels
disp('Loading features (including CDRs) and labels');

% Load CDR features
load(featuresFilePathCDR);
% Load labels
load(labelsFilePath);

% If there are more than just 1 cdr, compute the mean value;
if (size(cdrs, 2) > 1)
    cdrs = mean(cdrs, 2);
end
features = cdrs;

% Remove the variables indicating the paths
clear labelsFilePath featuresFilePathCDR

%% Normalize the features and generate different trials by randomizing different orderings of the features

disp(strcat('Generating ', num2str(options.numTrials), ' random splits'));
randomizeOrderings = cell(options.numTrials,1);
for i = 1 : options.numTrials
    [~, ~, fold.testIndices] = generateSplits(size(features,1), options.trainingFraction, 1 - options.trainingFraction);
    randomizeOrderings{i} = fold;
end

%% Experiment

results.scores = [];
results.labelsVals = [];
results.byFold.qualities = zeros(options.numTrials, 1);

res_byFold_qualities = zeros(options.numTrials, 1);
res_scores = cell(options.numTrials, 1);
res_labelsVals = cell(options.numTrials, 1);
res_testIndices = cell(options.numTrials, 1);

% For each split
for k = 1 : options.numTrials
    
    % Display the number of split
    fprintf('\n======== Processing trial number %d ========\n', k);
    
    % Retrieve the current split
    currentSplit = randomizeOrderings{k};
    
    % Test data
    [testdata] = generateStructOfData(currentSplit.testIndices, features, labels, 0);
    
    % Evaluate on the test set
    if (options.verbose)
        disp('Evaluating on the test set');
    end
    % Compute the scores
    currentScores = testdata.features;
    % Evaluate using the performance measure as indicated in options
    res_byFold_qualities(k) = evaluateResults(testdata.labels, currentScores, options.measure);   
    % Save all the probabilities
    res_scores{k} = currentScores;
    % Save the labels and the test indices
    res_labelsVals{k} = testdata.labels;
    res_testIndices{k} = testdata.indices;
    
end

% restore the scores and labels arrays
results.scores = zeros( round((1 - options.trainingFraction) * size(features, 1)) * options.numTrials, 1 );
results.labelsVals = zeros( round((1 - options.trainingFraction) * size(features, 1)) * options.numTrials, 1 );
results.testIndices = zeros( round((1 - options.trainingFraction) * size(features, 1)) * options.numTrials, 1 );
for k = 1 : options.numTrials
    results.scores( ((k-1) * round((1 - options.trainingFraction) * size(features, 1))+1):(k * round((1 - options.trainingFraction) * size(features, 1))) ) = res_scores{k};
    results.labelsVals( ((k-1) * round((1 - options.trainingFraction) * size(features, 1))+1):(k * round((1 - options.trainingFraction) * size(features, 1))) ) = res_labelsVals{k};
    results.testIndices( ((k-1) * round((1 - options.trainingFraction) * size(features, 1))+1):(k * round((1 - options.trainingFraction) * size(features, 1))) ) = res_testIndices{k};
end
results.byFold.qualities = res_byFold_qualities;


%% Evaluate the quality using the ROC curve

% Display the number of split
fprintf('======== Experiments finished! ========\n');

% Mean area under the ROC curve
results.mean_auc = mean(results.byFold.qualities(:));
fprintf('Average AUC = %d', results.mean_auc);

%% Save the results
save(strcat(saveResultsPath, filesep, 'results.mat'), 'results');