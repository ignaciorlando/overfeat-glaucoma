
function [g] = sigmoid(z)
% sigmoid Applies sigmoid function on the variable z:
% g = 1 / (1 + exp(-z))
% INPUT: z = array of double values
% OUTPUT: g = array of double values

    % Compute the sigmoid function
    g = 1 ./ (1 + exp(-z));

end