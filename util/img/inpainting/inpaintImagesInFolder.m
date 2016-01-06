
diskSize = 3;
imagesPath = 'C:\_cnn_inpainting\images';
vesselPath = 'C:\_cnn_inpainting\vessels';
outputPath = 'C:\_cnn_inpainting\inpainted';
upsampleFactor = 2.967;

% retrieve image names...
imgNames = dir(imagesPath);
imgNames = {imgNames.name};
imgNames = imgNames(3:end);
% retrieve vessel names...
vesselNames = dir(vesselPath);
vesselNames = {vesselNames.name};
vesselNames = vesselNames(3:end);

% for each image
for i = 1 : length(imgNames)
    disp(num2str(i));
    if (i==10)
        a = 1;
    end
    % open the image
    I = imread(strcat(imagesPath, filesep, imgNames{i}));
    % open the vasculature segmentation
    vessels = imread(strcat(vesselPath, filesep, vesselNames{i})) > 0;
    % inpaint the vessels in the original image
    newI = inpaintvessels(I, vessels, diskSize);
    % upsample the image to the original resolution
    newI = imresize(newI, upsampleFactor);
    % save the image
    imwrite(newI, strcat(outputPath, filesep, imgNames{i}));
    
end