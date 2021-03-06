


% For each regularizer
for i_reg = 1 : length(regularizers)
    % For each zoom
    for i_data = 1 : length(dataUsed)
        % For each crop shape
        for i_shape = 1 : length(shapes)
            % For each augmentation strategy
            for i_aug = 1 : length(augmented)
                
                % Configure the experiments
                options.dataUsed = dataUsed{i_data};
                options.augmented = augmented{i_aug};
                options.shape = shapes{i_shape};
                options.regularizer = regularizers{i_reg};
                options
                
                % Run the experiment!
                configureAndRunExperiment(dataset, rootFolder, resultsFolder, options);
                %crossvalidationEXTERNAL
        
            end
        end
    end
end