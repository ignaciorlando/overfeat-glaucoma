% Open multiple files from a given directory
function allNames = getMultipleImagesFileNames(directory, remove_mat_files)
    
    % By default, remove_mat_files = true
    if (exist('remove_mat_files', 'var')==0)
        remove_mat_files = true;
    end
    
    % Get all file names
    allFiles = dir(directory);
    % Get only the names of the images inside the folder
    allNames = {allFiles.name};
    allNames(strcmp(allNames, '..')) = [];
    allNames(strcmp(allNames, '.')) = [];
    
    % Remove mat files when necessary
    if (remove_mat_files)
        allNames = removeFileNamesWithExtension(allNames, 'mat');
    end
end
