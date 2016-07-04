
config_crop_images_automatically;


for idx_prepro_type = 1 : length(preprocessings_names)

    % retrieve current preprocessing strategy
    current_preprocessing_strategy = preprocessings_names{idx_prepro_type};
    
    % for each crop type
    for idx_crop_type = 1 : length(crop_types)

        % identify current crop type
        current_crop_type = crop_types{idx_crop_type};

        % prepare full path of the crops
        current_crops_path = fullfile(crops_path, current_crop_type);
        % retrieve crop names
        crop_names = getMultipleImagesFileNames(current_crops_path, false);

        % prepare image path
        current_image_path = fullfile(image_path, current_preprocessing_strategy, 'im');
        % prepare output path
        current_output_path = fullfile(output_path, current_preprocessing_strategy, current_crop_type);
        if (exist(current_output_path, 'dir')==0)
            mkdir(current_output_path);
        end

        % retrieve images names
        image_names = getMultipleImagesFileNames(current_image_path);

        % for each image
        for i = 1 : length(image_names)

            % open the image
            I = imread(fullfile(current_image_path, image_names{i}));
            % open the crop
            load(fullfile(current_crops_path, filesep, crop_names{i}));

            % readjust crop to current resolution
            sub_image = sub_image * downscale_factor;
            % get only the corresponding part of the image
            newI = I(sub_image(2):sub_image(2)+sub_image(4),sub_image(1):sub_image(1)+sub_image(3), :);

            % save current crop
            imwrite(newI, fullfile(current_output_path, image_names{i}));

        end

    end
    
end
