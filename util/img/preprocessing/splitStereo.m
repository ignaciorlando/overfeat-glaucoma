
% Split stereo images

% Path where the images are saved
imagePath = 'C:\SharedFolderWithUbuntu\RIM-ONE-db-r3\Healthy\im-fov-crop-ste';
outputPath = 'C:\SharedFolderWithUbuntu\RIM-ONE-db-r3\Healthy\im-fov-crop';
% Extension of image files
extension = '.jpg';

% Retrieve the names of the files in the folder
imageNames = dir(imagePath);
imageNames = {imageNames(~[imageNames.isdir]).name};
idx = ~cellfun('isempty', regexp(imageNames, extension));
imageNames = imageNames(idx);

% For each image
for i = 1 : length(imageNames)
    
    % Show the image
    %imshow(imread(strcat(imagePath, filesep, imageNames{i})));
    
    fprintf('%d/%d\n',i,length(imageNames));
    
    % Open the image
    image_ = imread(strcat(imagePath, filesep, imageNames{i}));
    
    % Split the image, half and half
    image_length = size(image_, 2);
    % Take the first half of the image
    image_1 = image_(:, 1:floor(image_length/2), :);
    % Take the second half of the image
    image_2 = image_(:, floor(image_length/2)+1:end, :);
    
    % Get image name
    image_tag = strtok(imageNames{i}, '.');
    
    % Save each half
    imwrite(image_1, strcat(outputPath, filesep, image_tag, '_left', extension));
    imwrite(image_2, strcat(outputPath, filesep, image_tag, '_right', extension));
    
end