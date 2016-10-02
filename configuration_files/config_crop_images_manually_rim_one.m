
% Data set
%dataset = fullfile('RIM-ONE r3','left_side');
dataset = fullfile('RIM-ONE r3','right_side');

% Crop images
%cropType = 'rectangle';
cropType = 'square';

% Path where the images are saved
imagePath = fullfile('C:\_glaucoma', dataset, 'im');
outputPath = fullfile('C:\_glaucoma', dataset, 'im-fov-crop');

% Extension of image files
extension = '.png';