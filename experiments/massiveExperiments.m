
% Data set name
dataset = 'Drishti';

% Identify the machine
[ret, hostname] = system('hostname');
hostname = strtrim(lower(hostname));

% Lab computer
if strcmp(hostname, 'orlando-pc')
    % Folder where the features and labels are
    rootFolder = 'C:\_glaucoma\_resources\data';
    % Folder where the results will be saved
    resultsFolder = 'C:\_glaucoma\results';
elseif strcmp(hostname, 'animas')
    % Folder where the features and labels are
    rootFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/_resources/data';
    % Folder where the results will be saved
    resultsFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/results';
end

% Indicate type of image to be used
options.typeImage = 'original';
% Indicate if the CDR will be included
options.useCDR = false;

% Different preprocessings of the images. Warning: all will be explored!
shapes = {'rectangle', 'square', 'clahe'};
shapesNames = {'Irregular crop', 'Regular crop', 'Regular crop + CLAHE'};

% Regularizers. Warning: all will be explored!
%regularizers = {'L1','L2','k-support'};
regularizers = {'L1', 'L2'};

% Augmentation strategies. Warning: all will be explored!
augmented = {'', '-aug-90', '-aug'};
augmentedNames = {'Not augmented', 'Flipped and rotated 90º', 'Flipped and rotated 45º'};

% Zooms. Warning: all will be explored!
dataUsed = {'down', 'fov-crop-down', 'od-down' , 'only-od-down'};
dataUsedNames = {'Original image', 'Cropped FOV', 'OD + surrounding tissue', 'Only OD'};

% Measure to optimize
options.measure = 'auc';
%options.measure = 'acc';
% Verbose option
options.verbose = false;

% % Type of experiment: Cross validation
% options.experimentType = 'cross-validation';
% % Number of folds
% options.folds = 10;
% Type of experiment: Multiple trials
options.experimentType = 'multiple-trials';
% Number of folds
options.numTrials = 100;
% Training fraction
options.trainingFraction = 0.7;

% Lambda values
% options.lambdaValues = 10.^(-1:1:1); % lambda values
options.lambdaValues = 10.^(-5:1:6); % lambda values


% For each regularizer
for i_reg = 1 : length(regularizers)
    % For each zoom
    for i_data = 1 : length(dataUsed)
        % For each crop shape
        for i_shape = 1 : length(shapes)
            % For each augmentation strategy
            for i_aug = 1 : length(augmented)
                
                % Configure the experiments
                options.dataUsed = dataUsed{i_data};
                options.augmented = augmented{i_aug};
                options.shape = shapes{i_shape};
                options.regularizer = regularizers{i_reg};
                options
                
                % Run the experiment!
                configureAndRunExperiment(dataset, rootFolder, resultsFolder, options);
                %crossvalidationEXTERNAL
        
            end
        end
    end
end