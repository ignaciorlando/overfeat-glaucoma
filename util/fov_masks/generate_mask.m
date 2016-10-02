
function [mask] = generate_mask(I, threshold)

    if (exist('threshold', 'var')==0)
        threshold = 0.02;
    end

    % Get each color band
    if (size(I,3)>1)
        RGB = I;
    else
        RGB = cat(3, I, I, I);
    end

    % Get the CIELab color representation
    [Lab] = rgb2lab(RGB);
    L = Lab(:,:,1)./100;
    
    % Threshold it
    mask = logical((1- (L < threshold)) > 0);
    
    % If the resulting mask has only ones, then sum up the RGB bands and
    % threshold it
    if length(unique(mask(:)))==1
        mask = sum(I, 3) > 150;
    end
    
    % Fill holes and apply median filter
    mask = imfill(mask,'holes');
    mask = medfilt2(mask, [5 5]);
    
    % Get connected components
    CC = bwconncomp(mask);
    
    % The largest connected component is the mask
    componentsLength = cellfun(@length, CC.PixelIdxList);
    [~, indexes] = sort(componentsLength, 'descend');
    mask = bwareaopen(mask,componentsLength(indexes(1))-1);
    
end