
function [] = vggs_fine_tune(vggs_net, num_output_classes, new_dataset_path, export_path)
%VGGS_FINE_TUNE_DRISHTI Demonstrates fine-tuning a VGG-S on Drishti
%  This demo demonstrates training the VGG-S architecture on Drishti data.

    % initialize the net with VGG-S configuration
    old_net = vl_simplenn_tidy(vggs_net) ;

    % retrieve options
    [opts] = get_opts_fine_tuning(new_dataset_path, export_path);
    
    % create again the dropout layers
    drop1 = struct('name', 'dropout6', 'type', 'dropout', 'rate', 0.5);
    drop2 = struct('name', 'dropout7', 'type', 'dropout', 'rate', 0.5);
    
    % add dropout layers in the corresponding place
    old_net.layers = [old_net.layers(1:15) drop1 ...
                      old_net.layers(16:17) drop2 ...
                      old_net.layers(18:end)];
    
    % remove the last 2 layers (fully-connected + softmax)
    net.layers = old_net.layers(1:end-2);
    
    % add 2 new layers, one fully-connected with output = #clases
    net = add_block(net, opts, '8', 1, 1, 4092, num_output_classes, 1, 0);
    
    % add a new softmax layer
    net.layers(end) = [];
    net.layers{end + 1} = struct('type', 'softmax');
    
    
    
    
    
    
    
    
    
    
    
    
    % load and preprocess an image
    im = imread('peppers.png') ;
    im_ = single(im) ; % note: 0-255 range
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    im_ = bsxfun(@minus, im_, net.meta.normalization.averageImage) ;

    % run the CNN
    res = vl_simplenn(net, im_) ;

    % show the classification result
    scores = squeeze(gather(res(end).x)) ;
    [bestScore, best] = max(scores) ;
    figure(1) ; clf ; imagesc(im) ;
    title(sprintf('%s (%d), score %.3f',...
    net.meta.classes.description{best}, best, bestScore)) ;
    In order to compile the GPU support and other advanced features, see the installation instructions.

end


% --------------------------------------------------------------------
function net = add_block(net, opts, id, h, w, in, out, stride, pad)
% --------------------------------------------------------------------
    info = vl_simplenn_display(net) ;
    fc = (h == info.dataSize(1,end) && w == info.dataSize(2,end)) ;
    if fc
      name = 'fc' ;
    else
      name = 'conv' ;
    end
    convOpts = {'CudnnWorkspaceLimit', opts.cudnnWorkspaceLimit} ;
    net.layers{end+1} = struct('type', 'conv', 'name', sprintf('%s%s', name, id), ...
                               'weights', {{init_weight(opts, h, w, in, out, 'single'), ...
                                 ones(out, 1, 'single')*opts.initBias}}, ...
                               'stride', stride, ...
                               'pad', pad, ...
                               'learningRate', [1 2], ...
                               'weightDecay', [opts.weightDecay 0], ...
                               'opts', {convOpts}) ;
    if opts.batchNormalization
      net.layers{end+1} = struct('type', 'bnorm', 'name', sprintf('bn%s',id), ...
                                 'weights', {{ones(out, 1, 'single'), zeros(out, 1, 'single'), ...
                                   zeros(out, 2, 'single')}}, ...
                                 'learningRate', [2 1 0.3], ...
                                 'weightDecay', [0 0]) ;
    end
    net.layers{end+1} = struct('type', 'relu', 'name', sprintf('relu%s',id)) ;
end