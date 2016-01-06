
function [I_extended, mask_extended] = preprocessing(I, mask, options)
% preprocessing Preprocess the given image
% I = preprocessing(I, mask, options)
% OUTPUT: I: image preprocessed
% INPUT: I: image (it can be a RGB image)
%        mask: a binary mask indicating the FOV
%        options: a configuration structure containing the options

    if (~isfield(options, 'preprocess') || (isfield(options, 'preprocess') && options.preprocess))

        % get only the green band of the original color image
        I = (I(:,:,2));
        % estimate the background
        %background = medfilt2(I, [options.winSize options.winSize]);
        % remove the estimated background
        %I = double(I) - double(background);
        %I = uint8((I - min(I(:))) / (max(I(:)) - min(I(:))) * 255);
        % CLAHE enhancement
        if strcat(options.enhancement,'clahe')
            I = double(adapthisteq(I));
        end
        % noise reduction
        %I = anisodiff2D(I, 5, 1/7, 30, 2);
        % extend the borders using the fakepad function
        [I_extended, mask_extended] = fakepad(I, mask, options.erosion, options.fakepad_extension);
               
    end
    
end