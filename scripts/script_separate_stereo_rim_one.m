config_separate_stereo_rim_one;

% initialize an array of labels
labels = [];

% generate output paths
current_output_path_left = fullfile(output_path, 'left_side', 'images');
if (exist(current_output_path_left, 'dir')==0)
    mkdir(current_output_path_left);
end
current_output_path_right = fullfile(output_path, 'right_side', 'images');
if (exist(current_output_path_right, 'dir')==0)
    mkdir(current_output_path_right);
end

% for each subfolder
for j = 1 : length(subfolders)

    % generate input path
    current_input_path = fullfile(input_path, subfolders{j}, 'Stereo Images');

    % retrieve image filenames
    image_filenames = getMultipleImagesFileNames(current_input_path);

    % if images are glaucomatous
    if (strcmp(subfolders{j}, 'Glaucoma and suspects'))
        labels = cat(1, labels, ones(length(image_filenames), 1));
    else
        labels = cat(1, labels, zeros(length(image_filenames), 1));
    end
    
    % for each filename
    for i = 1 : length(image_filenames)
        
        % read the image
        I = imread(fullfile(current_input_path, image_filenames{i}));

        % find the coordinate to split image in two
        middle_coordinate = size(I,2) / 2;
        
        % left image
        left_image = I(:, 1:middle_coordinate, :);
        % right image
        right_image = I(:, middle_coordinate + 1 : end, :);

        % retrieve image name and extension
        [~, img_name, img_ext] = fileparts(image_filenames{i});
        if (strcmp(img_ext, '.jpg'))
            img_ext = '.png';
        end
        
        % save both images
        imwrite(left_image, fullfile(current_output_path_left, strcat(img_name, '_LC', img_ext)));
        imwrite(right_image, fullfile(current_output_path_right, strcat(img_name, '_RC', img_ext)));
        
    end

end

% generate output paths for the labels
current_output_path_left = fullfile(output_path, 'left_side', 'labels');
if (exist(current_output_path_left, 'dir')==0)
    mkdir(current_output_path_left);
end
current_output_path_right = fullfile(output_path, 'right_side', 'labels');
if (exist(current_output_path_right, 'dir')==0)
    mkdir(current_output_path_right);
end

% save the labels
save(fullfile(current_output_path_left, 'labels.mat'), 'labels');
save(fullfile(current_output_path_right, 'labels.mat'), 'labels');