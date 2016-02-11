
function runVesselSegmentation(config)

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

    
    
    if (~config.learn.modelSelection)
        % Don't do model selection
        [model, config.qualityOverValidation, config] = learnConfiguredCRF(trainingdata, validationdata, config);
    else
        % Do model selection
        [model, config.C.value, config.qualityOverValidation, config] = completeModelSelection(trainingdata, validationdata, config);
    end
    
    
    
    % if there are labels in the test data
    if config.thereAreLabelsInTheTestData
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

    % Save the segmentations
    SaveSegmentations(config.resultsPath, config, results, model, testdata.filenames);
    
end