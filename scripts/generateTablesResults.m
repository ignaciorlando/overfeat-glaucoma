% Summarize results

preproStrategies = {'rectangle', 'square', 'clahe'};
imageConfigurations = {'down', 'fov-crop-down', 'od-down', 'only-od-down'};
augmentationTechniques = {'', '-aug-90', '-aug'};
regularizer='L2';

%resultsPath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
resultsPath = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results';



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
            if (strcmp(regularizer,'L1') || strcmp(regularizer,'L2'))
                load(strcat(subpathImages, augmentationTechniques{k}, filesep, regularizer, filesep, 'results.mat'));
            else
                load(strcat(subpathImages, augmentationTechniques{k}, filesep, 'results.mat'));
            end
            
            % assign the mean AUC value to the position on the table
            subtable(k,j) = results.mean_auc;
            
        end

    end
    
    % Assign the subtable
    resultsTables{i} = subtable;
    
end
