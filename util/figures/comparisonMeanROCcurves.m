
% Lab computer
if strcmp(get(com.sun.security.auth.module.NTSystem,'DomainSID'), 'S-1-5-21-2417359367-2741391723-3780137234')
    % Folder where the results will be saved
    resultsFolder = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results\multiple-trials';
else
    % Folder where the results will be saved
    resultsFolder = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results\multiple-trials';
end

% Different preprocessings of the images. Warning: all will be explored!
shapes = {'square'};
shapesNames = {'Regular crop'};

% Regularizers. Warning: all will be explored!
regularizers = {'L1','L2','k-support'};
% Augmentation strategies. Warning: all will be explored!
augmented = {'-aug'};
augmentedNames = {'Flipped and rotated 45º'};
% Zooms. Warning: all will be explored!
dataUsed = {'fov-crop-down'};
dataUsedNames = {'Cropped FOV'};



figure;
% for each regularizer
aucs = zeros(size(regularizers));
legends = {};
count = 1;
for i = 1 : length(regularizers)

    % generate file name
    filename = strcat(resultsFolder, filesep, shapes{1}, filesep, dataUsed{1}, augmented{1}, filesep, regularizers{i}, filesep, 'results.mat');
    % if the file exists
    if (exist(filename, 'file'))
        % load the results file
        load(filename);
        % generate the mean ROC curve
        [aucs(i), AVR_X, AVR_Y, MCC, SCORE] = generateMeanROCCurve(results.scores, results.labelsVals, size(results.searches,3));
        plot(AVR_X, AVR_Y)
        hold on
        % incorporate the legend
        legends{count} = strcat(regularizers{i}, ' norm. AUC=', num2str(aucs(i)));
        count = count + 1;
    end

end
legend(legends, 'location', 'southeast');
xlabel('False positive rate (1 - Sp)');
ylabel('True positive rate (Se)');
if (strcmp(augmented{1}, ''))
    title(strcat('Results on', {' '}, dataUsedNames{1}, {' '}, 'images without augmenting the training set'));
else
    title(strcat('Results on', {' '}, dataUsedNames{1}, {' '}, 'images augmenting the training set'));
end
grid on