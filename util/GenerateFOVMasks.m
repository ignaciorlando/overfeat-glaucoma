
% Assign the folder names
folder = strcat(root, filesep, 'images');
folder_masks = strcat(root, filesep, 'masks');
if (exist(folder_masks, 'dir') == 0)
    mkdir(folder_masks)
end
% Determine a threshold
%threshold = 0.01; % DRISHTI
threshold = 0.02; % GlaucomaDB

% Get filenames
file_names = getMultipleImagesFileNames(folder);

% For each image
for i = 1 : length(file_names)
    
    % Open the image
    I = imread(strcat(folder, filesep, file_names{i}));
    % Get each color band
    if (size(I,3)>1)
        RGB = I;
    else
        RGB = cat(3, I, I, I);
    end

    % Get the CIELab color representation
    [Lab] = rgb2lab(RGB);
    L = Lab(:,:,1)./100;
    
    % Threshold it
    mask = logical((1- (L < threshold)) > 0);
    
    % If the resulting mask has only ones, then sum up the RGB bands and
    % threshold it
    if length(unique(mask(:)))==1
        mask = sum(I, 3) > 150;
    end
    
    % Fill holes and apply median filter
    mask = imfill(mask,'holes');
    mask = medfilt2(mask, [5 5]);
    
    % Get connected components
    CC = bwconncomp(mask);
    
    % The largest connected component is the mask
    componentsLength = cellfun(@length, CC.PixelIdxList);
    [~, indexes] = sort(componentsLength, 'descend');
    mask = bwareaopen(mask,componentsLength(indexes(1))-1);
    
    % Save the mask
    strtok(file_names{i}, '.')
    imwrite(mask, strcat(folder_masks, filesep, strtok(file_names{i}, '.'), '_mask', '.gif'));
    
end