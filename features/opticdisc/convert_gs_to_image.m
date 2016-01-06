function convert_gs_to_image( inDirImages, inDirLabels, outDir )
% convert_gs_to_image Converts the annotations stored in TXT files into
% BW images.
% INPUT: inDirImages = string with the path where the images are stored
%        inDirLabels = string with the path where the labels are stored
%        outDir = string with the path where the segmentation will be
%        stored

    % Retrieve the names of the images
    imgNames = dir(inDirImages);

    % For each image in the directory
    for i=1:length(imgNames)
        
        % If the image is not a directory
        if (~imgNames(i).isdir)
    
            % Load the image
            img = imread(fullfile(inDirImages, imgNames(i).name));           
            % Load the annotation file
            annotationName = strsplit(imgNames(i).name, '.');
            fid = fopen(fullfile(inDirLabels, strcat(annotationName{1}, '-gs.txt')));
            
            % Read the annotation file
            e = textscan(fid, '%s %s', 1);
            e = textscan(fid, '%s', 1, 'Delimiter', '\n');
            centro = textscan(fid, '%d %d', 1, 'Delimiter', '\n');
            puntos = textscan(fid, '%d %d', 16, 'Delimiter', '\n');
            % Close the file
            fclose(fid);
            
            % Draw the region of interest
            X1=interp([double(puntos{1}); double(puntos{1}(1))], 50);
            Y1=interp([double(puntos{2}); double(puntos{2}(1))], 50);
            [~, ~, ~, BW2, ~, ~] = roifill(zeros(size(img(:,:,1))), X1(1:16*50), Y1(1:16*50));

            % Save the file
            mask_file_name = annotationName{1};
            imwrite(BW2, fullfile(outDir, strcat(mask_file_name, '_mask.bmp')));

        end
    end

end

