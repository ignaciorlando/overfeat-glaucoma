

% CNN Configuration -------------------------------------------------------
% generate a temporal folder to save cnn weights
temp_folder = 'C:\my_temp_folder';
% path to the library
cnn_library_path = fullfile(pwd, 'util', 'external', 'matconvnet-1.0-beta20');
% type of convnet
% - vgg-s: CNN-S in "Return of devil is in the details".
% -
cnn_type = 'vgg-s'; cnn_dimensionality = 4096;

% Image configuration -----------------------------------------------------
% data set name
%datasets_names = {'Drishti', 'GlaucomaDB'}; 
datasets_names = {'Drishti'}; 
%datasets_names = {'GlaucomaDB'}; 
% root path
root_path = 'C:\SharedFolderWithUbuntu';
% output path
output_path = 'C:\_glaucoma\_resources\data_support';
% crop types
crop_types = { ...
    'im' ...    
    'im-fov-crop' ...
    'im-od' ...
    'im-only-od' ...
};
% preprocessings names
% preprocessings_names = { ...
%     'color'...
%     'color-inp' ...
%     'green' ...
%     'green-inp' ...
%     'norm-color'...
%     'norm-color-inp'...
%     'clahe-color'...
%     'clahe-color-inp'...
%     'green-clahe'...
%     'green-clahe-inp'...
% };
preprocessings_names = { ...
    'color'...
    'color-inp' ...
    'clahe-color'...
    'clahe-color-inp'...
};
% augmentation types
augs_types = { ...
    '' ...
    '-aug-90' ...
    '-aug' ...
};

% *************************************************************************
% *************************************************************************

% prepare cnn filename
cnn_filename = strcat('imagenet-', cnn_type, '.mat');
% prepare the path where the cnn weights will be located
cnn_weights_location = fullfile(temp_folder, cnn_filename);

% download and compile Matconvnet if it doesnt exist
if (exist(cnn_library_path, 'dir')==0)
    % install and compile MatConvNet (needed once)
    untar('http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta20.tar.gz') ;
    addpath(genpath(cnn_library_path));
    run vl_compilenn
end

% setup MatConvNet
run vl_setupnn

% if the temp_folder doesn't exist, create it
if (exist(temp_folder, 'dir')==0)
    % create folder
    mkdir(temp_folder);
end
% verify if the cnn file exists
if (exist(cnn_weights_location, 'file')==0)
    % download a pre-trained CNN from the web (needed once)
    urlwrite(...
      strcat('http://www.vlfeat.org/matconvnet/models/', cnn_filename), ...
      cnn_weights_location) ;
end

% load the pre-trained CNN
net = load(cnn_weights_location) ;
% remove fully connected layers
net.layers = net.layers(1:end-2);
% build the net
net = vl_simplenn_tidy(net) ;
