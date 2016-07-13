
config_cnn_feature_extraction;

% for each data set
for idx_dataset = 1 : length(datasets_names)

    % get current data set name
    current_dataset_name = datasets_names{idx_dataset};

    % for each preprocessing strategy
    for idx_prepro = 1 : length(preprocessings_names)
    
        % get current preprocessing strategy
        current_prepro = preprocessings_names{idx_prepro};
        
        % for each crop type
        for idx_crops = 1 : length(crop_types)

            % get current crop type
            current_crop_type = crop_types{idx_crops};
            
            % for each augmentation technique
            for idx_augs = 1 : length(augs_types)

                % get current augmentation technique
                current_aug = augs_types{idx_augs};

                % identify path where the images are stored
                current_image_path = fullfile(root_path, current_dataset_name, current_prepro, strcat(current_crop_type, current_aug))
                % prepare output path
                current_output_path = fullfile(output_path, current_dataset_name, 'features', current_prepro, strcat(current_crop_type, current_aug));
                if (exist(current_output_path, 'dir')==0)
                    mkdir(current_output_path);
                end
                
                % get images in current path
                image_names = getMultipleImagesFileNames(current_image_path);
                
                % initialize the feature matrix
                features = zeros(length(image_names), cnn_dimensionality);
                % for each image
                for i = 1 : length(image_names)

                    % load and preprocess an image
                    im = imread(fullfile(current_image_path, image_names{i})) ;
                    if (size(im,3)<3)
                        im2 = zeros(size(im,1), size(im,2), 3);
                        im2(:,:,1) = im;
                        im2(:,:,2) = im;
                        im2(:,:,3) = im;
                        im = im2;
                    end
                    im_ = single(im) ; % note: 0-255 range
                    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
                    %im_ = bsxfun(@minus, im_, net.meta.normalization.averageImage) ;

                    % run the CNN-S
                    res = vl_simplenn(net, im_) ;

                    % retrieve features
                    features(i,:) = squeeze(gather(res(end).x))' ;

                end
                
                if (strcmp(current_aug, ''))
                    info.names = image_names;
                    info.numFeatures = 1;
                elseif (strcmp(current_aug, '-aug-90'))
                    info.names = image_names;
                    info.numFeatures = 8;
                elseif (strcmp(current_aug, '-aug'))
                    info.names = image_names;
                    info.numFeatures = 16;
                end
                
                % output features
                save(fullfile(current_output_path, 'features.mat'), 'features', 'info');
                
            end
            
        end
        
    end

end