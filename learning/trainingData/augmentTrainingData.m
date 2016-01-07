
function [outputImages] = augmentTrainingData(images, angle)
% augmentTrainingData This function takes input images and labels and
% augment the data by taking different orientations and flipings of each
% image in the array.
% INPUT: images = cell-array containing the images to be transformed.
%        angle = rotation angle (in degrees)
% OUTPUT: outputImages = cell-array containing the already transformed
%           images.
%         outputLabels = array with the augmented list of labels.

    if (exist('angle','var')==0)
        angle = 90;
    end

    % Angles to rotate
    angles = 0:angle:359;
    
    % Initialize the cell array with the output images and the labels
    outputImages = cell(length(images),1);
    
    % Generate output images
    for i = 1 : length(images)
        
        disp(i);

        % Initialize the iterator
        iterator = 1;        
        
        % Generate a sub cell array with the different versions of the
        % input image
        versionsOfTheImage = cell(length(angles) * 2, 1);
        
        % For each of the angles in the list of angles
        for theta = angles
            % For each flip
            for flip_flag = 0 : 1
                % Rotate the image
                versionsOfTheImage{iterator} = imrotate(images{i}, theta, 'crop');
                if (flip_flag)
                    % Flip the image
                    versionsOfTheImage{iterator} = flip(versionsOfTheImage{iterator}, 2);
                end
                % Next position
                iterator = iterator + 1;
            end
        end
        
        % Copy the new versions of the image into the output array
        outputImages{i} = versionsOfTheImage;
        
    end

end