
warning('off','all');


[ret, hostname] = system('hostname');
hostname = strtrim(lower(hostname));
% Lab computer
if strcmp(hostname, 'orlando-pc')
    % Root dir where the data sets are located
    rootDatasets = 'C:\_glaucoma\datasets';
    % Root folder where the results are going to be stored
    rootResults = 'C:\_glaucoma\datasets';
    % Model location
    modelLocation = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\drgrading2016paper\data\segmentation-model';
end


datasetsNames = {...
    %'Drishti' ...
    'GlaucomaDB' ...
};
thereAreLabelsInTheTestData = 0 * zeros(size(datasetsNames));

load(strcat(modelLocation, filesep, 'model.mat'));
load(strcat(modelLocation, filesep, 'config.mat'));

% For each of the data sets
for i = 1 : length(datasetsNames)
              
        % Set the test path
        config.test_data_path = strcat(rootDatasets, filesep, datasetsNames{i});
        config.features.saveFeatures = 1;
        % Set the results path
        if (~strcmp(rootResults, 'training'));
            if strcmp(config.crfVersion, 'up')
                resultsPath = fullfile(rootResults, datasetsNames{i}, 'segmentations');
            else
                resultsPath = fullfile(rootResults, datasetsNames{i}, 'segmentations');
            end
            if (~exist(resultsPath,'dir'))
                config.output_path = resultsPath;
                mkdir(resultsPath);
            end
        end
        config.resultsPath = resultsPath;
        % Determine if there are test data
        config.thereAreLabelsInTheTestData = thereAreLabelsInTheTestData(i);
        % Run vessel segmentation!
        runVesselSegmentationUsingExistingModel(config, model)
    
end
        