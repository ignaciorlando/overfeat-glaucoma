
% Data set
%dataset = 'Drishti';
dataset = 'GlaucomaDB';
% Crop images
%cropType = 'rectangle';
cropType = 'square';

% Path where the images are saved
imagePath = fullfile('C:\SharedFolderWithUbuntu', dataset, 'im');
outputPath = fullfile('C:\SharedFolderWithUbuntu', dataset, 'im-only-od');

% Extension of image files
extension = '.jpg';

% Size of the initial guess
%sizeGuess = 'big';
sizeGuess = 'small';
%sizeGuess = 'too-small';