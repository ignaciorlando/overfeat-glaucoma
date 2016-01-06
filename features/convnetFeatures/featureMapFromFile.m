function [features, stride] = featureMapFromFile(filePath)
% featureMapFromFile Return a feature vector and information decoded from 
% an ASCII file loaded from filePath. The file was previously generated
% using OverFeat.
% Input: filepath = string with the path where the file is stored
% Output: features = vector with the features read from the file
%         stride = boolean indicating if a stride is used

    % Open file
    fid = fopen(filePath);
    
    % Read first line and separate the line using spaces
    line = strsplit(fgets(fid),' ');
    % Separate the number of features, the height of the image and the
    % width
    N = str2double(line{1});
    h = str2double(line{2});
    w = str2double(line{3});
    
    % Read next line and separate the line using spaces
    line = strsplit(fgets(fid),' ');
    line = line(1:end-1); % Remove the last char
    % Convert each cell to double
    line = cellfun(@str2double, line);
    % Reshape
    if (h*w~=1)
        features = permute(reshape(line(1:end-1),N,h,w), [2 3 1]);
        stride = 1;
    else
        features = line(:)';
        stride = 0;
    end
    
    % Close the file
    fclose(fid);

end