
warning('off','all');

% Datasets names
datasetsNames = {...
    %'DRIVE-DRISHTI' ...
    'DRIVE-GlaucomaDB' ...
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
rootDatasets = 'C:\_cnn\';

% Root folder where the results are going to be stored
rootResults = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\vessels\GlaucomaDB';
%rootResults = 'G:\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\vessels\DRISHTI\en_casa';



% For each of the data sets
for experiment = 1 : length(datasetsNames)

    % For each version of the CRF
    for crfver = 1 : length(crfVersions)
               
        % Get the configuration
        [config] = getConfiguration_GenericDataset(datasetsNames{experiment}, ... % data set name
                                                   strcat(rootDatasets, datasetsNames{experiment}), ... % data set folder
                                                   strcat(rootResults, filesep, datasetsNames{experiment}), ... % results folder
                                                   learnC, ... % learn C?
                                                   crfVersions{crfver}, ... % crf version
                                                   cValue ... % default C value
                                           );
        config.thereAreLabelsInTheTestData = thereAreLabelsInTheTestData(experiment);
        % Run vessel segmentation!
        runVesselSegmentation(config)
        
    end
    
end
        