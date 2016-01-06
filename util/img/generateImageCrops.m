

imagePath = 'C:\SharedFolderWithUbuntu\GlaucomaDB\clahe\im';
outputPath = 'C:\SharedFolderWithUbuntu\GlaucomaDB\clahe\im-only-od';
masksPath = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\imageCropsRectangles\GlaucomaDB\clahe\im-only-od';
cropTypes = {'clahe'};
%cropTypes = {'rectangle','square','clahe'};

% retrieve image names...
imgNames = dir(imagePath);
imgNames = {imgNames.name};
imgNames = imgNames(3:end);


for cropt = cropTypes
    
    % create dir
    dirName = strcat(outputPath, filesep);
    if (exist(dirName,'dir')==0)
        mkdir(dirName);
    end

    % crop each image in the indicated region
    for i = 1 : length(imgNames)
        disp(i);
        % open the image
        imagefilename = strcat(imagePath, filesep, imgNames{i});
        I = imread(imagefilename);
        % open the mask
        load(strcat(masksPath, filesep, imgNames{i}, '.mat'));
        % get the subpart of the image
        croppedI = I(sub_image(2):sub_image(2)+sub_image(4),sub_image(1):sub_image(1)+sub_image(3),:);
        % save
        imwrite(croppedI, strcat(dirName, filesep, imgNames{i}));

    end
    
end