
% Data set name
dataset = 'Drishti';

[ret, hostname] = system('hostname');
hostname = strtrim(lower(hostname));
% Lab computer
if strcmp(hostname, 'orlando-pc')
    % Folder where the features and labels are
    rootFolder = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data';
    % Folder where the results will be saved
    resultsFolder = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
elseif strcmp(hostname, 'animas')
    % Folder where the features and labels are
    rootFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/code/kSupport-CNN-glaucoma/_resources/data';
    % Folder where the results will be saved
    resultsFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/results';
else
    % Folder where the features and labels are
    rootFolder = 'G:\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data';
    % Folder where the results will be saved
    resultsFolder = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
end

% Type of experiment: Multiple trials
options.experimentType = 'multiple-trials';
% Number of folds
options.numTrials = 200;
%
options.trainingFraction = 0.7;
%
options.verbose = 0;
%
options.measure = 'auc';

% Run the experiment!
configureAndRunExperimentOnlyCDR(dataset, rootFolder, resultsFolder, options);