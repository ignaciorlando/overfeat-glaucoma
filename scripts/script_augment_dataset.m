
config_augment_dataset;

% for each zoom type
for i = 1 : length(zooms_list)

    % retrieve type of zoom
    zoom_name = zooms_list{i};
    
    % for each preprocessing strategy
    for k = 1 : length(preprocessings_names)

        % retrieve preprocessing type
        prepro_type = preprocessings_names{k};

        % prepare root path
        root_path = fullfile(root_folder, dataset_name, prepro_type);
        % retrieve images
        images_path = fullfile(root_path, zoom_name);
        
        % Read a bunch of images
        disp('Reading images');
        [images, image_names] = readBunchImages(images_path);
        
        % for each angle
        for j = 1 : length(angles)
            
            % retrieve current angle
            angle = angles(j);
            
            % generate output path
            if (angle==90)
                output_path = fullfile(root_path, strcat(zoom_name, '-aug-', num2str(angle)));
            else
                output_path = fullfile(root_path, strcat(zoom_name, '-aug'));
            end
            if (exist(output_path, 'dir')==0)
                mkdir(output_path);
            end

            % Augment data
            disp('Augmenting data');
            [augmentedImages] = augmentTrainingData(images, angle);

            % Save data
            disp('Saving images');
            writeAugmentedTrainingData(output_path, augmentedImages, image_names, 0);
            
        end
        
    end
end