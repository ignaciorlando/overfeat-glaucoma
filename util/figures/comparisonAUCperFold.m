
%shapes = {'rectangle', 'square', 'clahe'};
shapes = {'square', 'clahe'};
%shapesNames = {'Irregular crop', 'Regular crop', 'Regular crop + CLAHE'};
shapesNames = {'Regular crop', 'Regular crop + CLAHE'};

augmentations = {'', '-aug-90', '-aug'};
augmentationsNames = {'Not augmented', 'Flipped and rotated 90º', 'Flipped and rotated 45º'};

%configurations = {'down', 'fov-crop-down', 'od-down' , 'only-od-down'};
configurations = {'down'};
%configurationsName = {'Original image', 'Field of view', 'OD + surrounding tissue', 'Only optic disc'};
configurationsName = {'Original image'};

regularizer = 'L1';
typeImage = 'original';
datasetName = 'Drishti';
typeExperiment = 'multiple-trials';
numTrials = 200;

[ret, hostname] = system('hostname');
hostname = strtrim(lower(hostname));
% Lab computer
if strcmp(hostname, 'orlando-pc')
    % Folder where the results and labels are
    rootDir = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
    % Folder where the figures will be saved
    figuresRootPath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\figures';
elseif strcmp(hostname, 'animas')
    % Folder where the results and labels are
    rootFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/results';
    % Folder where the results will be saved
    figuresRootPath = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/figures';
else
    % Folder where the results and labels are
    rootDir = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
    % Folder where the figures will be saved
    figuresRootPath = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\figures';
end

verbose = 0;

%% Generate all plots

allResultsAsCellArray = cell(length(configurations), 1);
for ii = 1 : length(configurations)

    % Get names
    configuration = configurations{ii};
    configurationName = configurationsName{ii};
    
    %% Generate line plot

    % Generate a list of color
    colorlist=lines(length(shapes));

    numFolds = 0;
    resultsAsMatrix = [];
    resultsAsCellArray = cell(length(shapes), 1);
    for i = 1 : length(shapes)
        resultsAsCellArray{i} = zeros(numTrials, length(augmentations));
    end

    % For each augmentation configuration
    for k = 1 : length(augmentations)

        % For each configuration
        figure
        hold on
        legendStrings = {};

        for i = 1 : length(shapes)

            % Recover sub results matrix
            subResultsAsMatrix = resultsAsCellArray{i};

            % Load results
            load(strcat(rootDir, filesep, datasetName, filesep, typeExperiment, filesep, typeImage, filesep, shapes{i}, filesep, configuration, augmentations{k}, filesep, regularizer, filesep, 'results.mat'));

            % Concatenate results on the matrix
            subResultsAsMatrix(:,k) = results.byFold.qualities;

            % Concatenate sub results
            resultsAsMatrix = cat(2, resultsAsMatrix, results.byFold.qualities);
            
            % Plot the results per fold
            plot(1:length(results.byFold.qualities), results.byFold.qualities, '-', 'col', colorlist(i,:))
            numFolds = length(results.byFold.qualities);
            axis([1 length(results.byFold.qualities) 0 1]);
            legendStrings = cat(1, legendStrings, shapesNames{i});

            % Plot the mean performance
            plot(1:numTrials, ones(size(results.byFold.qualities)) * mean(results.byFold.qualities), '--', 'col', colorlist(i,:));
            legendStrings = cat(1, legendStrings, strcat(shapesNames{i}, ' - Average'));

            % Add results in the cell array
            resultsAsCellArray{i} = subResultsAsMatrix;

        end

        % Add information to the figure
        xlabel('Fold number');
        ylabel('Area under the ROC curve');
        title(strcat(configurationName, {' - '}, augmentationsNames{k}, {' - '}, 'AUC in different folds'));
        legend(legendStrings, 'Location', 'southeast');
        grid on
        box on
        hold off
        
        % Create figure dir
        figuresDir = strcat(figuresRootPath, filesep, datasetName, filesep, typeExperiment, filesep, typeImage, filesep, filesep, configuration, filesep, regularizer);
        if (exist(strcat(figuresDir), 'dir')==0)
            mkdir(figuresDir);
        end

        % Save in figuresDir
        print(strcat(figuresDir, filesep, configuration, '_', augmentationsNames{k}, '_', regularizer, '_line'), '-dpdf');
        print(strcat(figuresDir, filesep, configuration, '_', augmentationsNames{k}, '_', regularizer, '_line'), '-dpng');
        if (verbose==0)
            close all;
        end

    end

    %% Generate box plot
    
    h = figure;
    aboxplot(resultsAsCellArray, 'labels', augmentationsNames)%, 'positions', positions, 'boxstyle', 'filled')%, 'labels', shapesNames);
    ylim([0 1])
    ylabel('Area under the ROC curve');
    title(strcat(configurationName, {' - '}, 'Mean AUC'));
    legend(shapesNames, 'location', 'southeast');

    print(strcat(figuresDir, filesep, configuration, '_', regularizer, '_boxplot_mean'), '-dpdf');
    print(strcat(figuresDir, filesep, configuration, '_',  regularizer, '_boxplot_mean'), '-dpng');
    
    if (verbose==0)
        close gcf
    end

    allResultsAsCellArray{ii} = resultsAsMatrix;
    
end
