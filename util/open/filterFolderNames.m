function [filteredNames] = filterFolderNames(names)
% filterFileNames Filter an array of folders, removing '..' and '.' and
% file names from the list 
% Input: names = cellarray of strings with the file names
% Output: filteredNames = cellarray without '.' and '..' and file names

    isub = [names(:).isdir]; %# returns logical vector
    filteredNames = {names(isub).name}';
    filteredNames(ismember(filteredNames,{'.','..'})) = [];
    
end