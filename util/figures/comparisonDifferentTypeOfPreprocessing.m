% Summarize results
close all

preproStrategies = {'rectangle', 'square', 'clahe'};
preproStrategiesNames = {'Irregular crop', 'Regular crop', 'Regular crop + CLAHE'};
imageConfigurations = {'down', 'fov-crop-down', 'od-down', 'only-od-down'};
imageConfigurationsNames = {'Original image', 'FOV cropped', 'OD + surrounding tissues', 'Only OD'};
augmentationTechniques = {'', '-aug-90', '-aug'};
augmentationTechniquesNames = {'Not augmented', 'Flipped and rotated 90º', 'Flipped and rotated 45º'};

resultsPath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results';



% Initialize array of results tables
resultsTables = cell(length(preproStrategies), 1);

% For each of the preprocessing strategies
for i = 1 : length(preproStrategies)

    % Path corresponding to the preprocessing strategy
    subpath = strcat(resultsPath, filesep, preproStrategies{i});

    % Initialize the result table in this case
    subtable = zeros(length(augmentationTechniques), length(imageConfigurations));
    
    % For each configuration of the images
    for j = 1 : length(imageConfigurations)

        % Path corresponding to the image configuration
        subpathImages = strcat(subpath, filesep, imageConfigurations{j});
        
        % For each augmentation technique
        for k = 1 : length(augmentationTechniques)
            
            % load the results file
            load(strcat(subpathImages, augmentationTechniques{k}, filesep, 'results.mat'));
            
            % assign the mean AUC value to the position on the table
            subtable(k,j) = results.mean_auc;
            
        end

    end
    
    % Assign the subtable
    resultsTables{i} = subtable;
    
end

%%

% for i = 1 : length(preproStrategies)
%     
%     figure, plot(resultsTables{i}');
%     ylim([0 1]);
%     set(gca,'XTick',1:4,'XLim',[1 4]);
%     set(gca, 'XTickLabel', imageConfigurationsNames);
%     hh = rotateXLabels( gca, 45);
%     title(preproStrategiesNames{i});
%     ylabel('Mean Area under the ROC curve');
%     legend(augmentationTechniquesNames{1}, augmentationTechniquesNames{2});
%     grid on
%     
% end