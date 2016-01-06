
function [trainingSet, validationSet, testSet] = generateSplits(dataSize, trainingFraction, testFraction)
% generateSplits Returns indices to split a set into training, validation
% and test.
% INPUT: dataSize = number of elements on the training set
%        trainingFraction = a double value indicating the fraction of
%           elements on the training set (this set do not include the 
%           validation set).
%        testFraction = a double value indicating the fraction of elements
%           on the test set.
% OUTPUT: trainingSet = indices for the training set
%         validationSet = indices for the validation set
%         testSet = indices for the test set


    % Generate indices from 1 to dataSize, representing the indices of each
    % sample
    indices = 1:1:dataSize;
    
    % Compute the number of elements on the training, validation and test
    % sets
    if (exist('testFraction','var')==0)
        testFraction = 1 - trainingFraction;
    end
    trainingSize = round(length(indices) * trainingFraction * trainingFraction);
    testSize = round(length(indices) * testFraction);
    
    % Randomly sample "testSize" elements from the list of indices
    testSet = sort(randsample(indices, testSize));
    
    % Remove the test indices from the original list of indices
    remainingIndices = indices;
    remainingIndices(testSet) = [];
    % Generate a new list of indices, with index the remainingIndices array
    indicesOnRemaining = 1:1:length(remainingIndices);

    % Randomly sample "trainingSize" elements from the list of remaining
    % indices
    indicesOnRemaining_training = sort(randsample(indicesOnRemaining, trainingSize));
    trainingSet = remainingIndices(indicesOnRemaining_training);
    
    % Remove the training indices from the list of indices
    indicesOnRemaining(indicesOnRemaining_training) = [];
    
    % The remaining indices correspond to the validation set
    validationSet = remainingIndices(indicesOnRemaining);

end