
% Augment a data set
rootFolder = 'C:\SharedFolderWithUbuntu';
datasetName = 'Drishti-VC';
%zoomslist = {'im-down', 'im-fov-crop-down', 'im-od-down', 'im-only-od-down'};
zoomslist = {'im-down'};
angles = [45, 90];
%angles = [45];
preproType = 'square';

for i = 1 : length(zoomslist)
    for j = 1 : length(angles)
        
        

        % Dataset name
        zoomName = zoomslist{i};
        % Angle
        angle = angles(j);
        % Root path
        rootPath = strcat(rootFolder,filesep,datasetName,filesep,preproType);

        % Images path
        imagesPath = strcat(rootPath, filesep, zoomName);
        % Output path
        if (angle==90)
            outputPath = strcat(rootPath, filesep, zoomName, '-aug-', num2str(angle));
        else
            outputPath = strcat(rootPath, filesep, zoomName, '-aug');
        end
        if (exist(outputPath, 'dir')==0)
            mkdir(outputPath);
        end
        % Label path
        %labelPath = strcat('C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\data',filesep,datasetName);

        % Read a bunch of images
        disp('Reading images');
        [images, imageNames] = readBunchImages(imagesPath);

        % Load the labels file
        %load(strcat(labelPath, filesep, 'labels.mat'));

        % Augment data
        disp('Augmenting data');
        [augmentedImages] = augmentTrainingData(images, angle);

        % Save data
        disp('Saving images');
        writeAugmentedTrainingData(outputPath, augmentedImages, imageNames, 0);
        
    end
end