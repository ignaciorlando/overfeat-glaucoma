
%% -------------------------------------------------------------------------
% EXPERIMENT toyExampleDrishti
% -------------------------------------------------------------------------
% Open training, validation and test data, using features extracted from
%       the Drishti dataset using OverFeat
% Learn k-support regularized logistic regression
% Evaluate on the test set
% -------------------------------------------------------------------------

clear, clc;

%% Experiment configuration
disp('Setting up parameters');

% Path where the features are stored
featuresFilePath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data\Drishti\Training\features\original-downsampled\features-downsampled.mat';
% Path where the indices are stored
indicesFilePath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data\Drishti\Training\splits\toy-example-2.mat';
% Path where the labels are stored
labelsFilePath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data\Drishti\Training\labels.mat';

% Measure to optimize
options.measure = 'auc';
%options.measure = 'acc';

% Parameters to learn
% options.kValues = 2.^(1:4); % k values
% options.lambdaValues = 10.^(-3:1:2); % lambda values
options.kValues = 2.^(1:6); % k values
options.lambdaValues = 10.^(-10:1:5); % lambda values

%% Load features, indices and labels
disp('Loading features and labels');

% Load features
load(featuresFilePath);
% Load indices: trainingSet, validationSet, testSet, nonTestSet
load(indicesFilePath);
% Load labels
load(labelsFilePath);

% Remove the variables indicating the paths
clear featuresFilePath indicesFilePath labelsFilePath

%% Organize each set of information
disp('Organizing training, validation and test data');

% First, normalize to zero mean, unit variance
features = zscore(features);

% Training data
[trainingdata] = generateStructOfData(trainingSet, features, labels);
% Validation data
[validationdata] = generateStructOfData(validationSet, features, labels);
% Test data
[testdata] = generateStructOfData(testSet, features, labels);

% Remove the variables with the indices, the features and the labels
clear trainingSet validationSet testSet nonTestSet features labels

%% Set the hyperparameters lambda and k according to the validation set
[results] = estimateHyperParametersByGridSearch(trainingdata, validationdata, options);

%% Learn the k-support regularized logistic regression model based on the parameters
fprintf('Learning k-support regularized logistic regression using k=%d and lambda=%d\n', results.model.k, results.model.lambda);

% Train the k-support regularized logistic regresion model
[model.w, model.costs] = ksupLogisticRegression(trainingdata.features, trainingdata.labels, results.model.lambda, results.model.k);

%% Evaluate on the test set
disp('Evaluating on the test set');

% Compute the scores
testdata.scores = model.w' * testdata.features';

% Evaluate using the area under the ROC curve
[results.tpr, results.fpr, info] = vl_roc(testdata.labels, testdata.scores);
results.auc = info.auc;
fprintf('Test set ... AUC = %d\n', results.auc);

% Plot the ROC curve
figure, plot(1-results.fpr, results.tpr);
title('ROC curve');
xlabel('FPR (1 - Sensitivity)'); ylabel('TPR (Specificity)');