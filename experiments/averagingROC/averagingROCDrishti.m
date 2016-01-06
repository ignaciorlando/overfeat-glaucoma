
%% -------------------------------------------------------------------------
% EXPERIMENT averagingROCDrishti
% -------------------------------------------------------------------------
% Run several trials to estimate an average ROC curve
% - Generate random split
% - Perform model selection on several trials random sample of the training set
% - Learn k Support Logistic Regression Model using K and Lambda
% Save all trials
% -------------------------------------------------------------------------

clear, clc;

%% Experiment configuration
disp('Setting up parameters');

% Data to use
options.dataUsed = 'down';
options.augmented = 'no';

%% Run the experiment
if (strcmp(options.augmented, 'yes'))
    options.dataUsed = strcat(options.dataUsed, '-aug');
    
else
    experimentAveragingROC;
end