
function [data] = generateStructOfData(indices, features, labels, augmented)
% generateStructOfData Generate a data struct with indices, features and
% labels, retrieved from the features matrix and the labels array
% INPUT: indices = array with a list of the indices that corresponds to the
%            data that must be included in the data struct.
%        features = matrix where each row is a feature vector and each
%            column is a feature.
%        labels = array with 1 in the positive class and 0 in the negative
%            class.
%        augmented (optional) = a flag indicating if it is an augmented
%            training set (=1) or a validation/test set (=2) (default = 0,
%            not augmented)
% OUTPUT: data = struct with the fields:
%           .indices = indices;
%           .features = features(indices,:);
%           .labels = 2*labels(indices)-1;

    % By default, augmented = 0
    if (exist('augmented','var')==0) || (nargin < 4)
        augmented = 0;
    end

    % generate data struct extracting the corresponding data from features
    % and labels
    
    % copy indices
    data.indices = indices;

    % If the data set is not augmented
    if (~augmented)
    
        % Get only the features indicated on indices
        data.features = features(indices, :);
        
        % Get only the labels indicated on indices
        data.labels = labels(indices);
    
    else
        
        % If it is an augmented training data
        if (augmented == 1)
        
            % Get only the features indicated on indices
            data.features = cell2mat(features(indices));

            % Get only the labels indicated on indices
            data.labels = cell2mat(labels(indices));
            
        % if it is an augmented validation/test set
        else
            
            % Recover only the features indicated by the indices
            subfeatures = features(indices);
            sublabels = labels(indices);
            
            % Initialize the vector of features and labels to be returned
            data.features = zeros(length(subfeatures), size(cell2mat(subfeatures), 2));
            data.labels = zeros(size(indices));
            
            % For each feature, get only the first one (which is the
            % original, not transformed)
            for i = 1 : length(subfeatures)
                
                % Get all the transformed features and their corresponding
                % labels...
                subfeatures_ith = subfeatures{i};
                sublabels_ith = sublabels{i};
                % ... but take only the first one
                data.features(i, :) = subfeatures_ith(1, :);
                data.labels(i) = sublabels_ith(1);
                
            end
            
        end
        
    end
    
    % Rearrange the labels so -1 represents the negative class and +1
    % represents the positive one
    data.labels = 2 * data.labels - 1;

end