
function [preprocessed] = clahePreprocessing(I)
% clahePreprocessing Perform contrast-limited adaptive histogram
% equalization on the RGB canals separately.
% INPUT: I = RGB image.
% OUTPUT: preprocessed = CLAHE image
    if (size(I,3)>1)
        cform2lab = makecform('srgb2lab');
        LAB = applycform(I, cform2lab);
        L = LAB(:,:,1);
        LAB(:,:,1) = adapthisteq(L);
        cform2srgb = makecform('lab2srgb');
        preprocessed = applycform(LAB, cform2srgb);
    else
        preprocessed = adapthisteq(I);
    end
    
end