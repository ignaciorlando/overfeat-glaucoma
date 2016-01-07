% Estimate rectangles
datasetname = 'GlaucomaDB';
shape = 'square';
rootPath = strcat('C:\SharedFolderWithUbuntu', filesep, datasetname, filesep, shape);
outputRootPath = strcat('C:\Users\USUARIO\Dropbox\RetinalImaging\Code\kSupport-CNN-glaucoma\_resources\imageCropsRectangles', filesep, datasetname);

originalImagePath = strcat(rootPath,filesep,'im');
otherCropsPath = {'im-fov-crop','im-od','im-only-od'};


for i = 1 : length(otherCropsPath)
    
    subCropPath = strcat(rootPath, filesep, otherCropsPath{i});
    
    % Generate path
    outputPath = strcat(outputRootPath, filesep, shape, filesep, otherCropsPath{i});
    if (exist(outputPath,'dir')==0)
        mkdir(outputPath);
    end
    
    % Retrieve the names of the images
    imgNames = dir(subCropPath);
   
    % For each of the images in the list
    for j = 3 : length(imgNames)

        disp(strcat('searching image nº', num2str(j)));
        
        % Read and store the image
        smallSubImage = imread(strcat(subCropPath, filesep, imgNames(j).name));
        % Read and store the image
        I = imread(strcat(originalImagePath, filesep, imgNames(j).name));
       
        % Identify the subimage
        [sub_image] = getSubImage(I, smallSubImage);

        % Save it in the output path
        save(strcat(outputPath, filesep, imgNames(j).name, '.mat'), 'sub_image');
        
    end
    
end

if strcmp(shape,'square')
    