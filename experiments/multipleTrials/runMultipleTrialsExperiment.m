%% Experiment

results.scores = [];
results.labelsVals = [];
results.byFold.qualities = zeros(options.numTrials, 1);

res_byFold_qualities = zeros(options.numTrials, 1);
res_searches = zeros( length(options.kValues), length(options.lambdaValues), options.numTrials );
res_scores = cell(options.numTrials, 1);
res_labelsVals = cell(options.numTrials, 1);
res_testIndices = cell(options.numTrials, 1);

% For each split
parfor k = 1 : options.numTrials
    
    % Display the number of split
    fprintf('\n======== Processing trial number %d ========\n', k);
    
    % Retrieve the current split
    currentSplit = randomizeOrderings{k};
    
    % Training data
    [trainingdata] = generateStructOfData(currentSplit.trainingIndices, features, labels, ~strcmp(options.augmented,''));
    % Validation data
    [validationdata] = generateStructOfData(currentSplit.validationIndices, features, labels, ~strcmp(options.augmented,'')*2);
    % Test data
    [testdata] = generateStructOfData(currentSplit.testIndices, features, labels, ~strcmp(options.augmented,'')*2);
    
    % Set the hyperparameters lambda and k according to the validation set
    [sub_results, res_searches(:,:,k)] = estimateHyperParametersByGridSearch(trainingdata, validationdata, options);
    
    % Learn the k-support regularized logistic regression model based on the parameters
    if (options.verbose)
        fprintf('Learning k-support regularized logistic regression using k=%d and lambda=%d\n', sub_results.model.k, sub_results.model.lambda);
    end
    [mod_w, mod_costs] = ksupLogisticRegression(trainingdata.features, trainingdata.labels, sub_results.model.lambda, sub_results.model.k);

    % Evaluate on the test set
    if (options.verbose)
        disp('Evaluating on the test set');
    end
    % Compute the scores
    currentScores = mod_w' * testdata.features';
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
results.searches = res_searches;
results.byFold.qualities = res_byFold_qualities;


%% Evaluate the quality using the ROC curve

% Display the number of split
fprintf('======== Experiments finished! ========\n');

% Mean area under the ROC curve
results.mean_auc = mean(results.byFold.qualities(:));
fprintf('Average AUC = %d', results.mean_auc);

%% Save the results
save(strcat(saveResultsPath, filesep, 'results.mat'), 'results');