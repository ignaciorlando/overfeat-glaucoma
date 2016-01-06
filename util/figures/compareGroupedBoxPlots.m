figure
save_fig = 0;

%shapes = {'rectangle', 'square', 'clahe'};
%shapesNames = {'Irregular crop', 'Regular crop', 'Regular crop + CLAHE'};
shapes = {'square', 'clahe'};
shapesNames = {'Original', 'CLAHE'};

augmentations = {'', '-aug-90', '-aug'};
augmentationsNames = {'Not aug.', 'Aug. 90º', 'Aug. 45º'};
% augmentations = {'', '-aug-90'};
% augmentationsNames = {'Not aug.', 'Aug. 90º'};


configurations = {'down', 'fov-crop-down', 'od-down' , 'only-od-down'};
configurationsName = {'Original image', 'Cropped FOV', 'Peripapillary area', 'ONH'};
% configurations = {'down'};
% configurationsName = {'Original image'};
% configurations = {'down', 'fov-crop-down'};
% configurationsName = {'Original image', 'Cropped FOV'};
% configurations = {'down', 'fov-crop-down', 'od-down'};
% configurationsName = {'Original image', 'Cropped FOV', 'OD + surrounding tissue'};

[ret, hostname] = system('hostname');
hostname = strtrim(lower(hostname));
% Lab computer
if strcmp(hostname, 'orlando-pc')
    % Folder where the results and labels are
    rootDir = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
    % Folder where the figures will be saved
    figuresRootPath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\paper\figures';
elseif strcmp(hostname, 'animas')
    % Folder where the results and labels are
    rootFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/results';
    % Folder where the results will be saved
    figuresRootPath = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/figures';
else
    % Folder where the results and labels are
    rootDir = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
    % Folder where the figures will be saved
    figuresRootPath = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\paper\figures';
end

regularizer = 'L2';
%typeImage = 'original';
typeImage = 'vesselInpainted';
datasetName = 'Drishti';
typeExperiment = 'multiple-trials';
numTrials = 200;
sameplot = 1;

%% Generate all the plots
statistics = cell(length(configurations), 1);
for ii = 1 : length(configurations)
    
    % Get names
    configuration = configurations{ii};
    configurationName = configurationsName{ii};
    
    % Create figure dir
    if (~sameplot)
        figuresDir = strcat(figuresRootPath, filesep, datasetName, filesep, typeExperiment, filesep, typeImage, filesep, regularizer, filesep, configuration);
    else
        figuresDir = strcat(figuresRootPath, filesep, datasetName, filesep, typeExperiment, filesep, typeImage, filesep, regularizer);
    end
    if (exist(strcat(figuresDir), 'dir')==0)
        mkdir(figuresDir);
    end
    
    % Accummulate the results
    numFolds = 0;
    dataToPlot = zeros(numTrials, length(augmentations), length(shapes));

    % Generate the statistics per shape
    statistics_per_shape = zeros(3, length(augmentations), length(shapes));
    
    % For each augmentation configuration
    for k = 1 : length(augmentations)

        % For each configuration
        for i = 1 : length(shapes)

            % Load results
            load(strcat(rootDir, filesep, datasetName, filesep, typeExperiment, filesep, typeImage, filesep, shapes{i}, filesep, configuration, augmentations{k}, filesep, regularizer, filesep, 'results.mat'));
            % Concatenate results on the matrix
            dataToPlot(:,k,i) = results.byFold.qualities;
            % Plot the results per fold
            numFolds = length(results.byFold.qualities);
            
            % Compute statistics
            statistics_per_shape(1, k, i) = mean(results.byFold.qualities);
            statistics_per_shape(2, k, i) = median(results.byFold.qualities);
            statistics_per_shape(3, k, i) = std(results.byFold.qualities);

        end

    end
    
    statistics{ii} = statistics_per_shape;

    %% Generate box plot
    if ~sameplot
        
        h = figure;  
        %axes('ylim', [0 1], 'color', 'none', 'YAxisLocation', 'right')
        colormap summer
        [~, handlers] = box_plot(augmentationsNames, dataToPlot, ...
            'boxColor', 'auto', ...
            'medianColor', 'k', ...
            'notch', true, ...
            'xSeparator', 'true', ...
            'symbolMarker', 'none' ... 
            );   
        ylim([0 1]);
        ylabel('Area under the ROC curve');
        grid on
        box on
        title(strcat(configurationName));%, {' - '}, 'AUCs distribution'));
        legend(squeeze(handlers.boxes(:,1,:)),shapesNames,'location','southeast')
        set(h, 'XTickLabelRotation', 15.0);
        if (save_fig)
            print(strcat(figuresDir, filesep, configuration, '_boxplot'), '-dpdf');
            print(strcat(figuresDir, filesep, configuration, '_boxplot'), '-dpng');
        end
        
    else
        
        h = subplot(1, length(configurations), ii);
        set(h, 'XTickLabelRotation', 15.0);
        colormap summer
        [~, handlers] = box_plot(augmentationsNames, dataToPlot, ...
            'boxColor', 'auto', ...
            'medianColor', 'k', ...
            'notch', true, ...
            'xSeparator', 'true', ...
            'symbolMarker', 'none' ... 
            );   
        ylim([0 1]);
        %ylabel('Area under the ROC curve');
        grid on
        box on
        title(strcat(configurationName));%, {' - '}, 'AUCs distribution'));
        if (ii==length(configurations))
            legend(squeeze(handlers.boxes(:,1,:)),shapesNames,'location','southeast')
        end
        
    end
    
end


save(strcat(figuresDir, filesep, 'statistics.mat'), 'statistics');

%close all