
function [results, search] = estimateHyperParametersByGridSearch(trainingdata, validationdata, options)
% estimateHyperParametersByGridSearch This function estimate the
% hyperparameters for the k support logistic regression model (k and
% lambda) by grid search, training on trainingdata and evaluation on
% validationdata.
% INPUT: trainingdata = training data, organized as a struct with:
%           .features = a matrix where each row corresponds to the feature
%               vector of an image
%           .labels = a vector of labels (1 the positive, -1 the negative)
%        validationdata = training data, organized as the training data
%           struct.
%        options = a struct with the fields:
%           .kValues = an array with the values of k to be evaluated
%           .lambdaValues = an array with the values of lambda to be
%               evaluated.
%           .measure = metric to be optimized
%           .verbose = print the progress of the model selection
% OUTPUT: results = a struct with the following fields:
%           .validationset.qualvalues = results for each combination of k
%               and lambda on the validation set
%           .model.k = the best value of k
%           .model.lambda = the best value of lambda
%         search = a matrix with results at each iteration

    if (~isfield(options, 'verbose'))
        options.verbose = true;
    end

    % Set the hyperparameters lambda and k according to the validation set
    if (options.verbose)
        disp('Initializing grid search');
    end
    
    % Setting up the grid search of parameters
    results.validationset.qualvalues = zeros(length(options.kValues), length(options.lambdaValues));
    
    % If not verbose, we will only show the percentage of advance
    %if (~options.verbose)
    %    totalIterations = length(options.kValues) * length(options.lambdaValues);
    %    currentIteration = 1;
    %end
    
    % Estimate the parameters using grid search
    for i = 1 : length(options.kValues)
        for j = 1 : length(options.lambdaValues)
            % Select the parameters k and lambda
            kval = options.kValues(i);
            lambda = options.lambdaValues(j);
            if (options.verbose)
                fprintf('Trying parameters k=%d, lambda=%d\n', kval, lambda);
            %else
                %fprintf('%i/%i...', currentIteration, totalIterations);
                %currentIteration = currentIteration + 1;
            end
            % Train the k-support regularized logistic regresion
            [w, costs] = ksupLogisticRegression(trainingdata.features, trainingdata.labels, lambda, kval);
            % Generate scores on the validation data
            validationdata.scores = w' * validationdata.features';
            % Evaluate using the performance measure as indicated in options
            results.validationset.qualvalues(i,j) = evaluateResults(validationdata.labels, validationdata.scores, options.measure);
            if (options.verbose)
                fprintf('%s=%d\n\n', options.measure, results.validationset.qualvalues(i,j));
            end
        end
    end
    
    % Retrieve the higher quality value on the validation set
    [results.validationset.highqual, index] = max(results.validationset.qualvalues(:));
    % If there are several results with the same area under the ROC curve, just
    % retrieve the first parameters
    if (length(index)>1)
        index = index(1);
    end
    % Retrieve the values of k and lambda    
    [k_ind, lambda_ind] = ind2sub(size(results.validationset.qualvalues), index);
    % Assign the data to the model struct
    results.model.k = options.kValues(k_ind);
    results.model.lambda = options.lambdaValues(lambda_ind);
    
    % Reshape the array with the results of the search
    search = reshape(results.validationset.qualvalues, length(options.kValues), length(options.lambdaValues));

end