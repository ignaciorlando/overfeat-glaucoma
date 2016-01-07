function configureAndRunExperiment(dataset, rootFolder, resultsFolder, options)
%
%
%
%
    
    % ---------------------------------------------------------------------
    % Determining the paths
    % ---------------------------------------------------------------------
    disp('Setting up parameters');
    
    % Path where the features are stored
    featuresFilePathCDR = strcat(rootFolder, filesep, dataset, filesep, 'features', filesep, 'cdrs.mat');

    % Path where the labels are stored
    labelsFilePath = strcat(rootFolder, filesep, dataset, filesep, 'labels.mat');
    % Path where the output is going to be saved
    % resultsFolder/dataset/experimentType/original/square/only-CDR/regularizer
    saveResultsPath = strcat(resultsFolder, filesep, dataset, filesep,options.experimentType, filesep, 'only-CDR');
    if (exist(saveResultsPath, 'dir') == 0)
        mkdir(saveResultsPath);
    end

    % ---------------------------------------------------------------------
    % Final configuration
    % ---------------------------------------------------------------------
    
    if (strcmp(options.experimentType, 'multiple-trials'))
        % Number of trials
        if (~isfield(options, 'numTrials'))
            options.numTrials = 200;
            disp(strcat('The number of trials was not previously set. We will use ', num2str(options.numTrials)));
        end
    end

    % ---------------------------------------------------------------------
    % Run the experiment
    % ---------------------------------------------------------------------
    
    % if it is multiple-trials
    if (strcmp(options.experimentType, 'multiple-trials'))   
        % Run the experiment
        runMultipleTrialsExperimentOnlyCDR;
    end

end