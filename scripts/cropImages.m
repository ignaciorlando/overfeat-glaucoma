
% Data set
%dataset = 'Drishti';
dataset = 'GlaucomaDB';
% Crop images
%cropType = 'rectangle';
cropType = 'square';

% Path where the images are saved
imagePath = strcat('C:\SharedFolderWithUbuntu', filesep, dataset, filesep, cropType, filesep, 'im-od');
outputPath = strcat('C:\SharedFolderWithUbuntu', filesep, dataset, filesep, cropType, filesep, 'im-only-od');
% Extension of image files
extension = '.jpg';
% Size of the initial guess
%sizeGuess = 'big';
sizeGuess = 'small';
%sizeGuess = 'too-small';

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
figure
for i = 1 : length(imageNames)
    
    fprintf('%d/%d\n',i,length(imageNames));
    
    % Open image
    I = imread(strcat(imagePath, filesep, imageNames{i}));
    
    % Show the image
    imshow(I);  
       
    % Draw initial rectangle
    if (strcmp(sizeGuess, 'big'))
        % Compute the original coordinate
        origCoord = floor(size(I,1)/6);
    elseif (strcmp(sizeGuess, 'small'))
        % Compute the original coordinate
        origCoord = floor(size(I,1)/4);
    else
        % Compute the original coordinate
        origCoord = floor(size(I,1)/3.25);
    end
    initialGuess = [origCoord, origCoord, size(I,1)-2*origCoord, size(I,1)-2*origCoord];
    h = imrect(gca, initialGuess);
    if (strcmp(cropType,'square'))
        setFixedAspectRatioMode(h, 1);
    end
    position = wait(h);

    % Crop the rectangle
    rect = imcrop(I,position);
    
    % Save the rectangle
    imwrite(rect, strcat(outputPath, filesep, imageNames{i}));
    
end