
%% -------------------------------------------------------------------------
% EXPERIMENT crossvalidationDrishti_fov_crop_down
% -------------------------------------------------------------------------
% Cross validation on Drishti
% Learn k-support regularized logistic regression on each training set
% Evaluate on each test set
% Concatenate each test set
% -------------------------------------------------------------------------

clear, clc;

%% Experiment configuration
disp('Setting up parameters');

% Data to use
options.dataUsed = 'fov-crop-down';
options.augmented = 'yes';
options.shape = 'rectangle';

%% Run the experiment
if (strcmp(options.augmented, 'yes'))
    options.dataUsed = strcat(options.dataUsed, '-aug-90');
    experimentCrossValidationAugmented;
else
    experimentCrossValidation;
end