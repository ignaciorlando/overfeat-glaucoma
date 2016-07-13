
function [opts] = get_opts_fine_tuning(dataset_path, output_path)

    % set up input/output paths
    opts.dataDir = dataset_path ;
    opts.expDir = output_path ;

    % multiclass (then labels must be 1 and 2)
    opts.errorFunction = 'multiclass';

    % model will be vgg-s and simplenn
    opts.model = 'vgg-s' ;
    opts.networkType = 'simplenn' ;
    
    % scale?
    opts.scale = 1 ;
    % initBias?
    opts.initBias = 0.1 ;
    % weightDecay?
    opts.weightDecay = 1 ;
    % initialization?
    %opts.weightInitMethod = 'gaussian' ;
    % batch normalization?
    opts.batchNormalization = false ;
    %opts.batchNormalization = true ;  
    
    % cuda options?
    opts.train = struct() ;
    if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;
    %opts.cudnnWorkspaceLimit = 1024*1024*1204 ; % 1GB
    %opts.numFetchThreads = 12 ;
    
    % ?
    %bs = 128;

    % lite?
    %opts.lite = false ;
    % wtf?
    %opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
    

end