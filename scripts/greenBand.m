
% Get only the green band
clear; clc;

% Dataset name
datasetNames = {'im-down','im-fov-crop-down','im-od-down','im-only-od-down','im-down-aug','im-fov-crop-down-aug','im-od-down-aug','im-only-od-down-aug','im-down-aug-90','im-fov-crop-down-aug-90','im-od-down-aug-90','im-only-od-down-aug-90'};
% datasetNames = {'im-fov-crop-down', 'im-fov-crop-down-aug', 'im-fov-crop-down-aug-90', ...
%     'im-od-down', 'im-od-down-aug', 'im-od-down-aug-90', ...
%     'im-only-od-down-aug','im-only-od-down-aug-90'};
% Root path
rootPath = 'C:\SharedFolderWithUbuntu\Drishti\green-clahe';

% For each of the data sets
for i = 1 : length(datasetNames)

    disp(datasetNames{i});
    
    % Images path
    imagesPath = strcat(rootPath, filesep, datasetNames{i});
    % Output path
    outputPath = strcat(rootPath, filesep, datasetNames{i});
    % Label path
    labelPath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data\Drishti';

    % Read a bunch of images
    disp('Reading images');
    [images, imageNames] = readBunchImages(imagesPath);

    % Load the labels file
    load(strcat(labelPath, filesep, 'labels.mat'));

    % Preprocess each image
    for j = 1 : length(images)
        % Preprocess image
        disp(strcat('Preprocessing image:', num2str(j)));
        I = images{j};
        [images{j}] = I(:,:,2);
        % Saving the image
        disp(strcat('Saving image:', num2str(j)));
        imwrite(images{j}, strcat(rootPath, filesep, datasetNames{i}, filesep, imageNames{j}));
    end

end