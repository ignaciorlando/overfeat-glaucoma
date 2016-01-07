
function [quality] = evaluateResults(labels, scores, measure)
% evaluateResults Given a string 'measure' indicating a measure to evaluate
% binary classifications, this function computes it using 'labels' as
% ground truth and 'scores' to estimate the corresponding labels.
% INPUT: labels = ground truth labelling
%        scores = likelihood of belonging to the positive class
%        measure = string indicating the performance measure that is going
%        to be computed
%           .auc = area under the roc curve
%           .acc = accuracy
% OUTPUT: quality = quality measure indicated in the 'measure' string

    quality = -Inf;
    if (size(labels,1) > size(labels,2))
        labels = labels';
    end
    
    % Area under the ROC curve
    if (strcmp(measure, 'auc'))
        
        [tpr, fpr, info] = vl_roc(labels, scores);
        quality = info.auc;
        
    % Accuracy
    elseif (strcmp(measure, 'acc'))
        
        quality = length(find(sign(scores)==labels))/length(labels);
        
    end


end
