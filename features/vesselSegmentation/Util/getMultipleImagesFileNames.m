% Open multiple files from a given directory
function allNames = getMultipleImagesFileNames(directory)
    % Get all file names
    allFiles = dir(directory);
    % Get only the names of the images inside the folder
    allNames = cell({allFiles.name});
    allNames = filterFileNames(allNames);
end

function [filteredNames] = filterFileNames(names)

    filteredNames = {};
    for i = 1:length(names)
        if (~strcmp(names{i},'..') && ~strcmp(names{i},'.'))
            if (isempty(filteredNames))
                filteredNames = names{i};
            else
                filteredNames = [filteredNames {names{i}}];
            end
        end
    end
    
end