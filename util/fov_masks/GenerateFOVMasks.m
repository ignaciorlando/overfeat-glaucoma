
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
    
    % Generate the mask
    [mask] = generate_mask(I, threshold);
    
    % Save the mask
    strtok(file_names{i}, '.')
    imwrite(mask, strcat(folder_masks, filesep, strtok(file_names{i}, '.'), '_mask', '.gif'));
    
end