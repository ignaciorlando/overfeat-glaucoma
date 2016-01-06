
% Path where the images are saved
imagePath = 'C:\_cnn\DRIVE-GlaucomaDB\test\images';
outputPath = 'C:\_cnn\DRIVE-GlaucomaDB\test\images';
% Extension of image files
extension = '.jpg';
% Relative reduction
scale = 0.409375;

% If the outputPath doesnt exists, create it
if (exist(outputPath, 'dir')==0)
    mkdir(outputPath);
end

% Retrieve the names of the files in the folder
imageNames = dir(imagePath);
imageNames = {imageNames(~[imageNames.isdir]).name};
idx = ~cellfun('isempty', regexp(imageNames, extension));
imageNames = imageNames(idx);

% For each image
for i = 1 : length(imageNames)
    
    fprintf('%d/%d\n',i,length(imageNames));
    
    % Open image
    I = imread(strcat(imagePath, filesep, imageNames{i}));
    
    % Save the rectangle
    imwrite( imresize(I, scale), strcat(outputPath, filesep, imageNames{i}));
    
end