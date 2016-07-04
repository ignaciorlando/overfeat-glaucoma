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
    % rootFolder/dataset/features/original/square/zoomtype-aug/feat-zoomtype-aug
    featuresFilePath = fullfile(rootFolder, dataset, 'features', options.typeImage, options.shape, strcat(options.dataUsed, options.augmented), strcat('feat-', options.dataUsed, options.augmented , '.mat'));
    if (options.useCDR)
        featuresFilePathCDR = strcat(rootFolder, filesep, dataset, filesep, 'features', filesep, 'cdrs.mat');
    end
    % Path where the labels are stored
    labelsFilePath = strcat(rootFolder, filesep, dataset, filesep, 'labels.mat');
    % Path where the output is going to be saved
    % resultsFolder/dataset/experimentType/original/square/zoomtype-aug/regularizer
    withCDR = '';
    if (options.useCDR)
        withCDR = '-withCDR';
    end
    saveResultsPath = strcat(resultsFolder, filesep, dataset, filesep,options.experimentType, filesep, options.typeImage, filesep, options.shape, filesep, options.dataUsed, options.augmented, withCDR, filesep, options.regularizer);
    if (exist(saveResultsPath, 'dir') == 0)
        mkdir(saveResultsPath);
    end

    % ---------------------------------------------------------------------
    % Experiment configuration
    % ---------------------------------------------------------------------
    
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

    % Parameters to learn
    if (strcmp(options.regularizer,'L1'))
        options.kValues = 1; % k = 1
    elseif (strcmp(options.regularizer,'L2'))
        options.kValues = 4096; % k = d
        if (options.useCDR)
            options.kValues = options.kValues + 1;
        end
    else
        if (~isfield(options, 'kValues'))
            % options.kValues = 2.^(1:2); % k values
            options.kValues = 2.^(1:6); % k values
            disp(strcat('No k values were originally set. We will use ', mat2str(options.kValues)));
        end
    end
    % Lambda values    
    if (~isfield(options, 'lambdaValues'))
        % options.lambdaValues = 10.^(-1:1:1); % lambda values
        options.lambdaValues = 10.^(-5:1:6); % lambda values
        disp(strcat('No k values were originally set. We will use ', mat2str(options.lambdaValues)));
    end

    % ---------------------------------------------------------------------
    % Final configuration
    % ---------------------------------------------------------------------
    
    % If the experiment type is based in cross-validate the data set
    if (strcmp(options.experimentType, 'cross-validation'))
        % Path where the sorting is stored
        crossvalFilePath = strcat(rootFolder, filesep, dataset, filesep, 'crossval.mat');
        % Number of folds
        if (~isfield(options, 'folds'))
            options.folds = 10;
            disp(strcat('The number of folds for cross-validation was not previously set. We will use ', num2str(options.folds)));
        end
    elseif (strcmp(options.experimentType, 'multiple-trials'))
        % Number of trials
        if (~isfield(options, 'numTrials'))
            options.numTrials = 200;
            disp(strcat('The number of trials was not previously set. We will use ', num2str(options.numTrials)));
        end
        % Training/test fraction
        if (~isfield(options, 'numTrials'))
            options.trainingFraction = 0.7;
            disp(strcat('The training/test fractions were not previously set. We will use ', num2str(options.trainingFraction), ' of the data for training'));
        end
    end

    % ---------------------------------------------------------------------
    % Run the experiment
    % ---------------------------------------------------------------------
    
    % if it is cross-validation
    if (strcmp(options.experimentType, 'cross-validation'))   
        % Run the experiment
        if (strcmp(options.augmented, 'no')==0)
            options.dataUsed = strcat(options.dataUsed, options.augmented);
            experimentCrossValidationAugmented;
        else
            experimentCrossValidation;
        end
    % if it is multiple-trials
    elseif (strcmp(options.experimentType, 'multiple-trials'))   
        % Run the experiment
        if (strcmp(options.augmented, '')==0)
            options.dataUsed = strcat(options.dataUsed, options.augmented);
            if (options.useCDR)
                configureMultipleTrialsExperimentAugmentedCDR;
            else
                configureMultipleTrialsExperimentAugmented;
            end
        else
            if (options.useCDR)
                configureMultipleTrialsExperimentCDR;
            else
                configureMultipleTrialsExperiment;
            end
        end
        runMultipleTrialsExperiment;
    end

end