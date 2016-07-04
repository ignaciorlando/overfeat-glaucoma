
function [J] = adapthisteqCOLOR(I)

    I = im2double(I);
    cform2lab = makecform('srgb2lab');
    LAB = applycform(I, cform2lab);
    L = LAB(:,:,1)/100;
    LAB(:,:,1) = adapthisteq(L,'NumTiles',...
                             [8 8],'ClipLimit',0.005)*100;
    cform2srgb = makecform('lab2srgb');
    J = applycform(LAB, cform2srgb);

end