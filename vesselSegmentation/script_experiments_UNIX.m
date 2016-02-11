
warning('off','all');

% Datasets names
datasetsNames = {...
    'DRIVE-DRISHTI' ...
    %'CHASEDB1-DRISHTI' ...
};
thereAreLabelsInTheTestData = [...
    0 ...
];

% Flag indicating if the value of C is going to be tuned according to the
% validation set
learnC = 0;
% CRF versions that are going to be evaluated
crfVersions = {'fully-connected'};


% C values
cValue = 10^2;

% Root dir where the data sets are located
rootDatasets = '/home/ignacioorlando/_tmi_experiments/';

% Root folder where the results are going to be stored
%rootResults = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\vessels\DRISHTI';
rootResults = '/home/ignacioorlando/results-last-all';


% Creating data set paths
datasetsPaths = cell(length(datasetsNames), 1);
for i = 1 : length(datasetsNames)
    datasetsPaths{i} = strcat(rootDatasets, datasetsNames{i});
end

% Creating results paths
resultsPaths = cell(length(datasetsNames), 1);
for i = 1 : length(datasetsNames)
    resultsPaths{i} = strcat(rootResults, filesep, datasetsNames{i});
end


for experiment = 1 : length(datasetsNames)

    for crfver = 1 : length(crfVersions)
               
        % Get the configuration
        [config] = getConfiguration_GenericDataset_UNIX(datasetsNames{experiment}, datasetsPaths{experiment}, resultsPaths{experiment}, learnC, crfVersions{crfver}, cValue);

        root = config.resultsPath;

        % Open training data labels
        [trainingdata.labels] = openVesselLabels(strcat(config.training_data_path, filesep, 'labels'));
        % Open training data labels
        [validationdata.labels] = openVesselLabels(strcat(config.validation_data_path, filesep, 'labels'));
        
        % Code name of the expected files
        pairwisedeviations = strcat(config.training_data_path, filesep, 'pairwisedeviations.mat');

        % If the pairwise deviation file does not exist
        if (exist(pairwisedeviations, 'file')~=2)
            % Compute all possible features
            [allfeatures, numberOfDeviations, ~, ~, ~] = extractFeatures(strcat(config.training_data_path, filesep, 'images'), ...
                                                                strcat(config.training_data_path, filesep, 'masks'), ...
                                                                config, ...
                                                                ones(size(config.features.numberFeatures)), ...
                                                                false);
            % Compute pairwise deviations
            pairwiseDeviations = getPairwiseDeviations(allfeatures, numberOfDeviations);
            % Save pairwise deviations
            save(pairwisedeviations, 'pairwiseDeviations');
        else
            % Load pairwise deviations
            load(pairwisedeviations); 
        end

        % Assign precomputed deviations to the param struct
        config.features.pairwise.pairwiseDeviations = pairwiseDeviations;
        clear 'pairwiseDeviations';

        % Extract unary features
        fprintf('Computing unary features\n');
        % Compute unary features on training data
        [trainingdata.unaryFeatures, config.features.unary.unaryDimensionality, trainingdata.numberOfPixels, trainingdata.masks, trainingdata.filenames] = extractFeatures(strcat(config.training_data_path, filesep, 'images'), ...
                                                                                                  strcat(config.training_data_path, filesep, 'masks'), ...
                                                                                                  config, ...
                                                                                                  config.features.unary.unaryFeatures, ...
                                                                                                  true);
        % Compute unary features on validation data
        [validationdata.unaryFeatures, ~, ~, validationdata.masks, validationdata.filenames] = extractFeatures(strcat(config.validation_data_path, filesep, 'images'), ...
                                                       strcat(config.validation_data_path, filesep, 'masks'), ...
                                                       config, ...
                                                       config.features.unary.unaryFeatures, ...
                                                       true);

        % Compute pairwise features on training data
        % Extract pairwise features
        [pairwisefeatures, config.features.pairwise.pairwiseDimensionality, ~, ~, ~] = extractFeatures(strcat(config.training_data_path, filesep, 'images'), ...
                                                                                              strcat(config.training_data_path, filesep, 'masks'), ...
                                                                                              config, ...
                                                                                              config.features.pairwise.pairwiseFeatures, ...
                                                                                              false);
        config.features.pairwise.pairwiseDeviations = config.features.pairwise.pairwiseDeviations(generateFeatureFilter(config.features.pairwise.pairwiseFeatures, config.features.pairwise.pairwiseFeaturesDimensions));
        trainingdata.pairwiseKernels = getPairwiseFeatures(pairwisefeatures, config.features.pairwise.pairwiseDeviations);

        % Compute pairwise features on validation data
        pairwisefeatures = extractFeatures(strcat(config.validation_data_path, filesep, 'images'), ...
                                           strcat(config.validation_data_path, filesep, 'masks'), ...
                                           config, ...
                                           config.features.pairwise.pairwiseFeatures, ...
                                           false);
        validationdata.pairwiseKernels = getPairwiseFeatures(pairwisefeatures, config.features.pairwise.pairwiseDeviations);

        % Filter the value of theta_p
        config.theta_p.finalValues = ...
            config.theta_p.values(generateFeatureFilter(config.features.pairwise.pairwiseFeatures, config.features.pairwise.pairwiseFeaturesDimensions));

        % Train with this configuration and return the model
        [model, config.qualityOverValidation, config] = learnCRFPotentials(config, trainingdata, validationdata);

        % if there are labels in the test data
        if thereAreLabelsInTheTestData(experiment)
            % Open training data labels
            [testdata.labels] = openVesselLabels(strcat(config.training_data_path, filesep, 'labels'));
        else
            testdata.labels = [];
        end
        
        % Extract unary features
        fprintf(strcat('Computing unary features\n'));
        [testdata.unaryFeatures, config.features.unary.unaryDimensionality, ~, testdata.masks, testdata.filenames] = extractFeatures(strcat(config.test_data_path, filesep, 'images'), ...
                                                                                              strcat(config.test_data_path, filesep, 'masks'), ...
                                                                                              config, ...
                                                                                              config.features.unary.unaryFeatures, ...
                                                                                              true);
        % Extract pairwise features
        fprintf(strcat('Computing pairwise features\n'));
        [pairwisefeatures, config.features.pairwise.pairwiseDimensionality, ~, ~, ~] = extractFeatures(strcat(config.test_data_path, filesep, 'images'), ...
                                                                                              strcat(config.test_data_path, filesep, 'masks'), ...
                                                                                              config, ...
                                                                                              config.features.pairwise.pairwiseFeatures, ...
                                                                                              false);
        % Compute the pairwise kernels
        fprintf(strcat('Computing pairwise kernels\n'));
        testdata.pairwiseKernels = getPairwiseFeatures(pairwisefeatures, config.features.pairwise.pairwiseDeviations);

        % Segment test data to evaluate the model
        [results.segmentations, results.qualityMeasures] = getBunchSegmentations2(config, testdata, model);

        SaveSegmentations(root, config, results, model, testdata.filenames);
        
    end
    
end
        