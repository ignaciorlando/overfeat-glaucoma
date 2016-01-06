
function [splits, sorting] = crossValidationSplits(sizeSet, nFolds, sorting)
% crossValidationSplits This function separates a set of size sizeSet into 
% nFold folds, random sampled from the original distribution of the data.
% INPUT: sizeSet = size of the set to be divided
%        nFolds = number of folds
%        sorting = indices of the original set
% OUTPUT: splits = cell array with the indices of the splits into training,
%            test and validation.
%         sorting = list of the indices of the images, sorted randomly

    % Initialize the cell-array of splits
    splits = cell(nFolds, 1);
    
    % The fold size will be the floor of length(indices) divided by the
    % number of folds. The last fold will have extra elements if it cannot 
    foldSize = floor(sizeSet / nFolds);
    
    % The validation size will be equal to 
    validationSize = floor(0.2 * (sizeSet - foldSize));
    
    % If the parameter sorting is an empty array, generate an array of 
    % numbers from 1 to sizeSet to represent the indices, and permute it
    % randomly
    indices = 1:1:sizeSet;
    if (isempty(sorting))
        sorting = indices(randperm(length(indices)));
    end
    
    % For each fold (except the last one)
    prev = 1;
    next = foldSize;
    for i = 1 : nFolds
        
        % Initialize an array with the indices already sorted randomly
        currentIndices = sorting;
        
        % Retrieve the test fold
        if (i == nFolds)
            next = sizeSet;
        end
        fold.testIndices = currentIndices(prev : next);
        currentIndices(prev:next) = [];
        
        % Retrieve the validation set
        tempIndices = randsample(1:length(currentIndices), validationSize);
        fold.validationIndices = currentIndices(tempIndices);
        currentIndices(tempIndices) = [];
        
        % The remaining images will correspond to the training data
        fold.trainingIndices = currentIndices;
        
        % Save the fold in the array
        splits{i} = fold;
        
        % Update prev and next
        prev = prev + foldSize;
        next = next + foldSize;
        
    end
    

end