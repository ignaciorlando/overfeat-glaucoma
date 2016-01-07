
function [training, test] = randomSplit(data, trainProportion)
% randomSplit This function separates data into training and test, where
% trainProportion indicates the proportion of the training set.
% INPUT: trainingSize = size of the training set
%        data = cell array of data
% OUTPUT: training = structure with training data
%         test = structure with test data

    % Generate an array of indices and randomly sort it
    sorting = randperm(size(data.features, 1));
    
    % Proportion of the test set
    trainSize = floor(trainProportion * length(sorting));
    
    % Split data in training and set
    training.features = data.features(sorting(1:trainSize), :);
    training.labels = data.labels(sorting(1:trainSize));
    test.features = data.features(sorting(trainSize+1:end), :);
    test.labels = data.labels(sorting(trainSize+1:end));

end