
config_crop_images_manually_rim_one;

% If the outputPath doesnt exists, create it
if (exist(outputPath, 'dir')==0)
    mkdir(outputPath);
end

% Retrieve the names of the files in the folder
imageNames = getMultipleImagesFileNames(imagePath);

% For each image
for i = 1 : length(imageNames)
    
    fprintf('%d/%d\n',i,length(imageNames));
    
    % Open image
    I = imread(strcat(imagePath, filesep, imageNames{i}));
    
    % generate the mask
    [mask] = generate_mask(I);
    
    % crop the image to cover only the FOV
    [ I, mask ] = cropFOV( I, mask );
    
    % estimate start-end points on each axis
    %[x_gradient, y_gradient] = get_fov_coordinates(mask);
    
    % estimate the size of the fovs
    x_size = size(I, 2);%x_gradient(2) - x_gradient(1);
    y_size = size(I, 1);%y_gradient(2) - y_gradient(1);
    % retrieve the radius
    if (x_size > y_size)
        radius = round(y_size / 2);
    else
        radius = round(x_size / 2);
    end
        
    % Show the image
    h = figure;
    imshow(I);    
    % assign (x,y) points
    [x, y] = getpts(h);
    
    % close the image
    close
    y = round(y);
    if (y - radius < 1)
        rect = I(1 : radius * 2, :, :);
    elseif (y + radius < size(I, 1))
        rect = I(y - radius : y + radius - 1, :, :);
    else
        rect = I(end - radius * 2 : end, :, :);
    end
    figure, imshow(rect)
    close
    
    % Save the rectangle
    imwrite(rect, strcat(outputPath, filesep, imageNames{i}));
    
end