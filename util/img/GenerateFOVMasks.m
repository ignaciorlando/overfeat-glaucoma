
folder = 'C:\Users\USUARIO\OneDrive\ARIA\aria_d_markups';
folder_masks = 'C:\Users\USUARIO\OneDrive\ARIA\aria_d_markups_masks';
if (exist(folder_masks, 'dir') == 0)
    mkdir(folder_masks)
end
threshold = 0.001;


close all;
[images, allNames] = openMultipleImages(folder);

for i = 1 : length(images)
    
    I = images{i};
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    [L,a,b] = RGB2Lab(R,G,B);
    L = L./100;
    mask = logical((1- (L < threshold)) > 0);
    mask = imfill(mask,'holes');
    mask = bwareaopen(mask, 50);
    mask = medfilt2(mask, [5 5]);

    %figure, imshow(mask);
    
    strtok(allNames{i}, '.')
    imwrite(mask, strcat(folder_masks, filesep, strtok(allNames{i}, '.'), '_mask', '.gif'));
    
end