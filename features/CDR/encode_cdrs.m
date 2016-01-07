function [cdrs] = encode_cdrs( inDirCDRs )
% encode_cdrs Encode the cup-to-disc ratios (CDR) stored in TXT files into 
% a matrix of CDR values. The format of the TXT files is as the files on
% Dristhi data set.
% INPUT: inDirLabels = string with the path where the cdrs are stored
% OUTPUT: cdrs = string with the path where the segmentation will be

    % Retrieve the names of the images
    imgNames = dir(inDirCDRs);

    % Initialize the cdrs matrix
    cdrs = zeros(length(imgNames)-2, 4);
    
    % For each image in the directory
    for i=1:length(imgNames)
           
        if (~strcmp(imgNames(i).name,'.')) && (~strcmp(imgNames(i).name,'..'))
              
            % Load the annotation file
            annotationName = strsplit(imgNames(i).name, '.');
            fid = fopen(fullfile(inDirCDRs, filesep, strcat(annotationName{1}, filesep, annotationName{1}, '_cdrValues.txt')));

            % Read the CDR file
            line = strsplit(fgets(fid),' ');
            % Close the file
            fclose(fid);

            % Separate the experts opinion
            for j=1 : length(line)
                cdrs(i-2,j) = str2double(line{j});
            end
            
        end

    end

end