
imagesPath = 'C:\_cnn_inpainting\images';
vesselPath = 'C:\_cnn_inpainting\vessels';
outputPath = 'C:\_cnn_inpainting\vesselsColored';
if (exist(outputPath, 'dir')==0)
    mkdir(outputPath);
end

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
    % open the image
    I = imread(strcat(imagesPath, filesep, imgNames{i}));
    % open the vasculature segmentation
    vessels = imread(strcat(vesselPath, filesep, vesselNames{i})) > 0;
    % inpaint the vessels in the original image
    for j = 1 : size(I, 3)
        I(:,:,j) = I(:,:,j) .* uint8(vessels);
    end
    % save the image
    imwrite(I, strcat(outputPath, filesep, imgNames{i}));
end