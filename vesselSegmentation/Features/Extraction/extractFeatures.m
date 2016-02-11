
function [features, dimensionality, numberOfPixels, masks, imgNames] = extractFeatures(imagesPath, masksPath, config, selectedFeatures, isUnary)
%
%
%
%

    % retrieve image names...
    imgNames = dir(imagesPath);
    imgNames = {imgNames.name};
    imgNames = imgNames(3:end);
    imgNames = removeFileNamesWithExtension(imgNames, 'mat');
    % ...and mask names
    mskNames = dir(masksPath);
    mskNames = {mskNames(3:end).name};
    % initialize number of pixels
    numberOfPixels = 0;
    
    % Remove features we will not include
    config.features.features(selectedFeatures==0) = [];
    config.features.featureParameters(selectedFeatures==0) = [];
    config.features.featureNames(selectedFeatures==0) = [];

    % Preallocate the cell array where the features will be stored
    features = cell(size(imgNames));
    % And where the masks will be stored
    masks = cell(size(imgNames));
    
    % for each image, verify if the feature file exist. if it is not there,
    % then we should compute it
    for i = 1 : length(imgNames)

        fprintf('Extracting features from %i/%i\n',i,length(imgNames));
        
        % open the mask
        mask = imread(strcat(masksPath, filesep, mskNames{i})) > 0;
        mask = mask(:,:,1);
        masks{i} = mask;
        
        % Generic function to compute features
        computedFeature = cell(size(config.features.features));
        
        % for each of the features
        for k = 1 : length(config.features.features)

            % generate feature file name
            if (isUnary)
                filenameFeature = strcat(imagesPath, filesep, imgNames{i}, '_', config.features.featureNames{k}, '_unary.mat');
            else
                filenameFeature = strcat(imagesPath, filesep, imgNames{i}, '_', config.features.featureNames{k}, '_pairwise.mat');
            end

            % if the feature exist, retrieve it
            if (exist(filenameFeature, 'file'))

                % load the feature file
                load(filenameFeature);

            % if it doesn't exist, we should generate it
            else

                % open the image
                image = imread(strcat(imagesPath, filesep, imgNames{i}));
                % preprocess the image
                [image, biggerMask] = preprocessing(image, mask, config.preprocessing);
                % get the function
                g = @(myfunction) myfunction(image, biggerMask, isUnary, config.features.featureParameters{k});
                % feature computation
                feat = cellfun(g, config.features.features(k), 'UniformOutput', false);
                % save the feature file
                save(filenameFeature, 'feat');
                
            end
            
            % retrieve the computed feature
            computedFeature{k} = feat{1};
            
        end
        
        % extend the mask
        biggerMask = zeros(size(mask,1) + 2 * config.preprocessing.fakepad_extension, size(mask,2) + 2 * config.preprocessing.fakepad_extension);
        biggerMask(config.preprocessing.fakepad_extension:end-config.preprocessing.fakepad_extension-1, ...
            config.preprocessing.fakepad_extension:end-config.preprocessing.fakepad_extension-1) = mask;
        mask = biggerMask;
        
        % Get the amount of pixels and the dimension of the feature vector
        dim1 = length(find(mask(:)==1));
        dim2 = 0;
        for k = 1 : length(computedFeature)
            dim2 = dim2 + size(computedFeature{k},3);
        end;
        X = zeros(dim1, dim2);

        % Encode feature vectors
        count = 1;
        for k = 1 : length(computedFeature)
            % Take the feature vectors of the i-th image
            feat = computedFeature{k};
            % If the feature vectors have 1 dimensionality
            if size(computedFeature{k},3)==1
                % Recover the feature vector inside the mask
                X(:,count) = feat(mask==1);
                count = count + 1;
            else
                % For each single feature in the feature vector
                for j = 1 : size(computedFeature{k},3)
                    % Recover the j-th feature
                    f = feat(:,:,j);
                    % Get only the feature vector inside the mask
                    X(:,count) = f(mask==1);
                    count = count + 1;
                end
            end
        end

        % feature scaling
        mu = mean(X);
        stds = std(X);
        stds(stds==0) = 1;
        X = bsxfun(@minus, X, mu);
        features{i} = bsxfun(@rdivide, X, stds);
        
        % increment the number of pixels
        numberOfPixels = numberOfPixels + size(features{i}, 1);
            
    end
        
    % return the dimensionality of the feature vector
    dimensionality = size(features{1}, 2);

    % remove the extension from all the filenames
    for i = 1 : length(imgNames)
        filename = imgNames{i};
        imgNames{i} = filename(1:end-4);
    end
    
end