
function [k, lambda, search] = multipleTrialsModelSelection(data, trainProportion, options)
% modelSelection 
% INPUT: data.features = 
%            .labels = 
%        trainProportion = 
%        options = 
% OUTPUT: k =
%         lambda =
%         search = 

    % Initialize matrix with results on each trial
    search = zeros(length(options.kValues), length(options.lambdaValues), options.trials);

    % Run several trials
    for i = 1 : options.trials
        
        % Divide training data into training and validation
        [training, validation] = randomSplit(data, trainProportion);
        % Model selection
        [~, search(:,:,i)] = estimateHyperParametersByGridSearch(training, validation, options);
       
    end
    
    % Accumulate along the third dimension to find the best combination of
    % parameters
    sum(search,3);
    
    % Learn the k-support regularized logistic regression model based on the parameters
    fprintf('Learning k-support regularized logistic regression using k=%d and lambda=%d\n', sub_results.model.k, sub_results.model.lambda);
    [model.w, model.costs] = ksupLogisticRegression(trainingdata.features, trainingdata.labels, sub_results.model.lambda, sub_results.model.k);

    

end