
%% -------------------------------------------------------------------------
% EXPERIMENT crossvalidationEXTERNAL
% -------------------------------------------------------------------------
% Cross validation on Drishti
% Learn k-support regularized logistic regression on each training set
% Evaluate on each test set
% Concatenate each test set
% -------------------------------------------------------------------------

disp('Setting up parameters');

%% Determining the paths

% Path where the features are stored
featuresFilePath = strcat(rootFolder, filesep, dataset, filesep, 'features', filesep, options.shape,filesep, options.dataUsed,filesep, 'feat-', options.dataUsed, '.mat');
% Path where the labels are stored
labelsFilePath = strcat(rootFolder, filesep, dataset, filesep, 'labels.mat');
% Path where the sorting is stored
crossvalFilePath = strcat(rootFolder, filesep, dataset, filesep, 'crossval.mat');
% Path where the output is going to be saved
if (strcmp(options.regularizer,'k-support-norm'))
    saveResultsPath = strcat(resultsFolder,filesep, options.shape, filesep, options.dataUsed);
else
    saveResultsPath = strcat(resultsFolder, filesep, options.shape, filesep, options.dataUsed, filesep, options.regularizer);
end
if (exist(saveResultsPath, 'dir') == 0)
    mkdir(saveResultsPath);
end


%% Experiment configuration

% If the regularizer doesnt exist
if ~isfield(options, 'regularizer')
    options.regularizer = 'k-support-norm';
    disp(strcat('Regularizer was not originally set. We will use ', options.regularizer));
end
% If the optimization metric doesnt exist
if ~isfield(options, 'measure')
    options.measure = 'auc';
    disp(strcat('Metric to be optimize was not originally set. We will use ', options.measure));
end

% Number of folds
options.folds = 10;

% Parameters to learn
if (strcmp(options.regularizer,'L1'))
    options.kValues = 1; % k = 1
elseif (strcmp(options.regularizer,'L2'))
    options.kValues = 4096; % k = d
else
    % options.kValues = 2.^(1:2); % k values
    options.kValues = 2.^(1:6); % k values
end
% Lambda values    
% options.lambdaValues = 10.^(-1:1:1); % lambda values
options.lambdaValues = 10.^(-5:1:6); % lambda values

%% Run the experiment
if (strcmp(options.augmented, 'no')==0)
    options.dataUsed = strcat(options.dataUsed, options.augmented);
    experimentCrossValidationAugmented;
else
    experimentCrossValidation;
end