
function [inpainted] = inpaintvessels(image, vessels, diskSize)

    % by default, diskSize = 2
    if (exist('diskSize', 'var')==0)
        diskSize = 3;
    end
    % dilate the vessel mask
    vessels = imdilate(double(vessels), strel('disk',diskSize,8)) > 0;
    % inpaint each band
    inpainted = image;
    for i = 1 : size(inpainted,3)
        subband = image(:,:,i);
        subband(vessels==1) = 0;
        inpainted(:,:,i) = regionfill(subband, vessels);
    end

end

