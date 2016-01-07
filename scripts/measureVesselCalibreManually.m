
rootPathImages = 'C:\_cnn\DRIVE-GlaucomaDB\test\images';
numImages = 5;
numProf = 3;

% Retrieve the names of the images
imgNames = dir(rootPathImages);

calibers = zeros(numImages, numProf);

% For each of the images in the list
for j = 3 : numImages+2

    disp(strcat('Measuring calibers of image', num2str(j)-2));

    % Read the image
    I = imread(strcat(rootPathImages, filesep, imgNames(j).name));
    imshow(I);
    
    % Compute the original coordinate
    origCoord = floor(size(I,1)/4);
    initialGuess = [origCoord, origCoord, size(I,1)-2*origCoord, size(I,1)-2*origCoord];
    h = imrect(gca, initialGuess);
    setFixedAspectRatioMode(h, 1);
    position = wait(h);
    % Crop the rectangle
    I = imcrop(I,position);
    
    % And now, we will use just that rectangle
    for i = 1 : numProf
        h = figure;
        imshow(I);
        set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
        profile = improfile;
        close all
        % Take the length of the profile as the calibre of the vessel
        calibers(j-2,i) = length(profile);
    end

end