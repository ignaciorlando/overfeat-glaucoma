
%% Initializing parameters

% Number of test trials
options.numTrials = 1000;

% Number of model selection trials
options.modelSelection.trials = 20;
% Optimization metric for the model selection process
options.modelSelection.metric = 'auc';
% Parameters to learn
options.modelSelection.kValues = 2.^(1:6); % k values
options.modelSelection.lambdaValues = 10.^(-4:1:9); % lambda values


%% Determining the paths

% Path where the features are stored
featuresFilePath = strcat('C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data\Drishti\features', filesep, options.dataUsed,filesep, 'feat-', options.dataUsed, '.mat');
% Path where the labels are stored
labelsFilePath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data\Drishti\labels.mat';
% Path where the output is going to be saved
saveResultsPath = strcat('C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results', filesep, options.dataUsed);


%% Load features, indices and labels
disp('Loading features and labels');

% Load features
load(featuresFilePath);
% Load labels
load(labelsFilePath);

% Remove the variables indicating the paths
clear featuresFilePath labelsFilePath


%% Normalize the features and generate the data struct

% Normalize features and generate the data struct
disp('Normalize features');
data.features = zscore(features);
data.labels = labels;

% Remove previous variables of feaures and labels
clear features labels


%% Experiment

% Run numTrials
for i = 1 : options.numTrials
    
    disp(strcat('Trial: ', num2str(i)));
    
    % Split data randomly
    [training, test] = randomSplit(data, 0.8);
    
    % Perform model selection
    [k, lambda, search] = multipleTrialsModelSelection(training, 0.8, options.modelSelection);
    
    
end