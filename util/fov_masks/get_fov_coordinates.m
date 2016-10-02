
function [x_gradient, y_gradient] = get_fov_coordinates(mask)

    % Identify coordinates of the empty area
    x_axis = double(sum(mask, 1) > 0);
    y_axis = double(sum(mask, 2) > 0);
    
    x_axis_shifted = circshift(x_axis, [0 1]);
    y_axis_shifted = circshift(y_axis, [1 0]);
    
    if (y_axis_shifted(1)==1)
        y_axis_shifted(1) = 0;
    end
    if (x_axis_shifted(1)==1)
        x_axis_shifted(1) = 0;
    end
    
    x_gradient = find(abs(x_axis - x_axis_shifted));
    y_gradient = find(abs(y_axis - y_axis_shifted));
    
    if isempty(y_gradient)
        y_gradient(1) = 1;
        y_gradient(2) = size(mask, 1);
    elseif length(y_gradient)==1
        y_gradient(2) = size(mask,1);
    end
    if isempty(x_gradient)
        x_gradient(1) = 1;
        x_gradient(2) = size(mask, 2);
    elseif length(x_gradient)==1
        x_gradient(2) = size(mask,2);
    end

end