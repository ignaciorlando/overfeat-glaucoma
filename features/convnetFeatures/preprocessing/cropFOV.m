function [ croppedFOV, croppedMask ] = cropFOV( I, mask )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    CC = bwconncomp(mask);
    componentsLength = cellfun(@length, CC.PixelIdxList);
    [~, indexes] = sort(componentsLength, 'descend');
    mask = bwareaopen(mask,componentsLength(indexes(1))-1);

    [x_gradient, y_gradient] = get_fov_coordinates(mask);
    
    % Get only the rectangle with the FOV
    if isa(I,'logical')
        croppedFOV = logical(zeros(y_gradient(2) - y_gradient(1) + 1, x_gradient(2) - x_gradient(1) + 1, size(I,3)));
    else
        croppedFOV = uint8(zeros(y_gradient(2) - y_gradient(1) + 1, x_gradient(2) - x_gradient(1) + 1, size(I,3)));
    end
    for i = 1 : size(I,3)
        croppedFOV(:,:,i) = I(y_gradient(1):y_gradient(2), x_gradient(1):x_gradient(2), i);
    end
    croppedMask = mask(y_gradient(1):y_gradient(2), x_gradient(1):x_gradient(2));

end

