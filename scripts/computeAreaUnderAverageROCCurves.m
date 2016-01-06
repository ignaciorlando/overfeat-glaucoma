
typeExperiment = 'multiple-trials';

numTrials = 200;

typesImage = {'original', 'vesselInpainted'};

shapes = {'square', 'clahe'};
shapesNames = {'Original', 'CLAHE'};

configurations = {'down', 'fov-crop-down', 'od-down' , 'only-od-down'};
configurationsName = {'Original image', 'Cropped FOV', 'Peripapillary area', 'ONH'};

augmentations = {'', '-aug-90', '-aug'};
augmentationsNames = {'Not aug.', 'Aug. 90º', 'Aug. 45º'};

regularizers = {'L1','L2'};


dataset = 'Drishti';
[ret, hostname] = system('hostname');
hostname = strtrim(lower(hostname));
% Lab computer
if strcmp(hostname, 'orlando-pc')
    % Folder where the results are saved
    resultsFolder = 'C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
elseif strcmp(hostname, 'animas')
    % Folder where the results are saved
    resultsFolder = '/home/ignacioorlando/nacho-research/cnn2015glaucoma/results';
else
    % Folder where the results are saved
    resultsFolder = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results';
end
resultsFolder = strcat(resultsFolder, filesep, dataset);


averageAUCs = cell(length(typesImage) * length(regularizers), 1);
stdevsAUCs = cell(length(typesImage) * length(regularizers), 1);
externalCount = 1;

for i = 1 : length(regularizers)
       
    for j = 1 : length(typesImage)
        
        myAUCs = zeros(1, length(configurations) * length(shapes) * length(augmentations));
        myAUCsDevs = zeros(1, length(configurations) * length(shapes) * length(augmentations));
        count = 1;
        
        for k = 1 : length(configurations)

            for l = 1 : length(shapes)
            
                for m = 1 : length(augmentations)

                    currentTest = strcat(typeExperiment, filesep, typesImage{j}, filesep, shapes{l}, filesep, configurations{k}, augmentations{m}, filesep, regularizers{i});
                    load(strcat(resultsFolder, filesep, currentTest, filesep, 'results.mat'));
                    [myAUCs(count), ~, ~, myAUCsDevs(count), ~] = generateMeanROCCurve(results.scores, results.labelsVals, numTrials);
                    count = count + 1;
                    
                end
                
            end
            
        end
        
        averageAUCs{externalCount} = myAUCs;
        stdevsAUCs{externalCount} = myAUCsDevs;
        externalCount = externalCount + 1;
        
    end
    
end


