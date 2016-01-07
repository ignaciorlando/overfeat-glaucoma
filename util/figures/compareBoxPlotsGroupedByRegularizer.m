
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
configurationsName = {'Original image', 'Cropped FOV', 'Peripapillary zone', 'ONH'};
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
    figuresRootPath = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\paper\figures\boxplot';
end

regularizers = {'L1','L2'};
typeImage = 'original';
%typeImage = 'vesselInpainted';
datasetName = 'Drishti';
typeExperiment = 'multiple-trials';
numTrials = 200;
sameplot = 1;


%% Generate all the plots
%figure
%count = 1;
for ii = 1 : length(configurations)

    hh = figure('Position', [100, 100, 400, 420])
    
    % Get names
    configuration = configurations{ii};
    configurationName = configurationsName{ii};
    
    %% Generate all the plots
    for reg = 1 : length(regularizers)

        regularizer = regularizers{reg};

        % Accummulate the results
        numFolds = 0;
        dataToPlot = zeros(numTrials, length(augmentations), length(shapes));

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

            end

        end

        %% Generate box plot
        %h = subplot(1, length(regularizers) * length(configurations), count);
        h = subplot(1, length(regularizers), reg);
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
        title(strcat(regularizers{reg}));%, {' - '}, 'AUCs distribution'));
        if (reg==length(regularizers))
            legend(squeeze(handlers.boxes(:,1,:)),shapesNames,'location','southeast')
            set(gcf,'NextPlot','add');
            axes;
            h = suptitle(configurationName);
            set(gca,'Visible','off');
            set(h,'Visible','on');
%             print(strcat(figuresRootPath, filesep, datasetName, '-', regularizer, '-', typeExperiment, '-', typeImage, '-', configuration), '-dpdf');
%             savefig(strcat(figuresRootPath, filesep, datasetName, '-', regularizer, '-', typeExperiment, '-', typeImage, '-', configuration));
        end
        %count = count + 1;

    end

end


%close all