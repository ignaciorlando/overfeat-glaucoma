function [z,h] = box_plot(varargin)
%BOX_PLOT Draw a box plot
% 
%   BOX_PLOT(Y) produces a box plot of the data in Y. If Y is a vector,
%   there is just one box. If Y is a matrix, there is one box per column.
%   If Y is an N-by-P-by-G-by-I-by-J... array then G*I*J*... boxes are
%   plotted hierarchically for each column P; i.e. J boxes are plotted for
%   each index of I, and J*I boxes are plotted for each index of G. For
%   each box, the central mark is the median of the data/column, the edges
%   of the box are the 25th and 75th percentiles, the whiskers extend to
%   the most extreme data points not considered outliers, and outliers are
%   plotted individually. NaNs are excluded from the data.
% 
%   Tabular data can be arranged into the appropriate format using the
%   TAB2BOX function.
% 
%   BOX_PLOT(X,Y) specifies the x-axis values for each box. X should be a
%   vector, with as many elements as Y has columns. The default is
%   1:SIZE(Y,2).
%   
%   BOX_PLOT(...,'PARAMETER',VALUE) allows the appearance of the plot to be
%   configured. See below for a full list of parameters.
% 
%   Z = BOX_PLOT(...) returns a structure Z containing the statistics used
%   for the box plot. With the exception of 'outliers' and 'outliers_IX'
%   noted below, each field contains a 1-by-P-by-G-by-I-by-J... numeric
%   array of values (identical to that returned by QUANTILE2). The fields
%   are:
%       'median'        : the median values
%       'N'             : the sample size
%       'Q1'            : the 25th percentiles
%       'Q3'            : the 75th percentiles
%       'IQR'           : the inter-quartile ranges
%       'min'           : the minimum values (excl. outliers)
%       'max'           : the maximum values (excl. outliers)
%       'notch_u'       : the upper notch values
%       'notch_l'       : the lower notch values
%       'outliers'      : a 1-by-P-by-G cell array of outlier values
%       'outliers_IX'   : a logical array, the same size as Y, with true
%                         values indicating outliers
% 
%   [Z,H] = BOX_PLOT(...) returns a structure containing handles to various
%   plot objects; each is a 1-by-P-by-G-by-I-by-J... array of handles. The
%   fields are 'axis' for the main axes, 'mlines' for the median lines,
%   'boxes' for the main boxes, 'outliers' for the outlier scatter,
%   'scatter' for the scatter plots (if the 'scatter' option is set),
%   and 'txtsample' for text objects (if the 'sampleSize' option is set).
%   The field 'txtg', for group text labels if 'style' is set to
%   'hierarchy', is also returned, but is a vector of handles: one for each
%   label.
% 
%   The parameters BOX_PLOT accepts are:
% 
%   ({} indicates the default value)
% 
%   'boxAlpha'          : Scalar {1}
%       Set the transparency of the boxes (0 is transparent, 1 is opaque).
%   'boxColor'          : ColorSpec | 'auto' | {'none'}
%       Fill color of the box; 'auto' means that Matlab's default colors
%       are used.
%   'boxWidth'          : scalar | {'auto'}
%       The width of the box. If set to 'auto', the widths are determined
%       automatically. Scalars correspond to x-axis units.
%   'groupLabelHeight'  : {'auto'} | scalar
%       Specify the height of the area reserved for group labels when the
%       'style' option is set to 'hierarchy'. The height is determined
%       automatically or can be specified in scale units.
%   'groupLabelFontSize'  : {9} | scalar
%       Specify the font size of the group labels when the 'style' option
%       is set to 'hierarchy'.
%   'groupLabels'        : {[]} | cell
%       If the 'style' option is set to 'hierarchy' then these labels will
%       be used to label the boxes for each x-group. The parameter should
%       be specified as a cell vector whereby the Nth element contains a
%       vector of length SIZE(Y,N+2).
%   'groupWidth'        : {0.7} | scalar
%       Specify the proportion of the x-axis interval across which each
%       x-group of boxes should be spread.
%   'limit'             : {'1.5IQR'} | '3IQR' |'none'
%       Mode indicating the limits that define outliers. When set to
%       '1.5IQR', the min and max values are Q1-1.5*IQR and Q3+1.5*IQR
%       respectively. When set to 'none', the min and max values are the
%       min and max of the data (in this case there will be no outliers).
%   'lineColor'         : ColorSpec {'k'} | 'auto'
%       color of the box outline and whiskers.
%   'lineStyle'         : {-} | -- | : | -. | none
%       Style of the whisker line.
%   'lineWidth'         : Scalar {1}
%       Width, in points, of the box outline, whisker lines, notch line,
%       and outlier marker edges.
%   'medianColor'       : ColorSpec | {'auto'}
%       color of the median line.
%   'method'            : 'R-1' | 'R-2' | 'R-3' | 'R-4' | 'R-5' | 'R-6' |
%                         'R-7' | {'R-8'} | 'R-9'
%       The method used to calculate the quantiles, labelled according to
%       http://en.wikipedia.org/wiki/Quantile. Although the default is
%       'R-8', the default for Matlab is 'R-5'.
%   'notch'             : true | {false}
%       Add a notch to the box. The notch is centred on the median and
%       extends to ±1.58*IQR/sqrt(N), where N is the sample size (number of
%       non-NaN rows in Y). Generally if the notches of two boxes do not
%       overlap, this is evidence of a statistically significant difference
%       between the medians.
%   'notchDepth'        : Scalar {0.4}
%       Depth of the notch as a proportion of half the box width.
%   'notchLine'         : true | {false}
%       Choose whether to draw a horizontal line in the box at the extremes
%       of the notch. (May be specified indpendently of 'notch'.)
%   'notchLineColor'    : ColorSpec {'k'} | 'auto'
%       color of the notch line.
%   'notchLineStyle'    : - | -- | {:} | -. | none
%       Line style of the notch line.
%   'outlierSize'       : Scalar {36}
%       Size, in square points, of the outlier marker.
%   'sampleFontSize'    : Scalar {9}
%       Specify the font size of the sample size display ('sampleSize' is
%       set to true).
%   'sampleSize'        : true | {false}
%       Specify whether to display the sample size in the top-right of each
%       box. Handles to the text objects are returned in H.TXTSAMPLE.
%   'scaleWidth'          : {false} | true
%       Scale the width of each box according to the square root of the
%       sample size.
%   'scatter'           : true | {false}
%       If set to true, a scatter plot of the underlying data for each box
%       will be overlayed on the plot. The data will have a random x-axis
%       offset with respect to the box centre. Handles to the scatter plots
%       are returned in H.SCATTER. Data that are outliers will not be
%       plotted.
%   'scatterAlpha'      : Scalar {1}
%       Set the transparency of the scatter markers (0 is transparent, 1 is
%       opaque).
%   'scatterLayer'      : {'top'} | 'bottom'
%       Set the layer of scatter plots with respect to the boxes.
%   'scatterMarker'     : '+' | 'o' | '*' | '.' | {'x'} |
%                         'square' or 's' | 'diamond' or 'd' | '^' | 'v' |
%                         '>' | '<' | 'pentagram' or 'p' | 'hexagram' or
%                         'h' | 'none'
%       Marker used for scatter plots of underlying data (if 'scatter' is
%       true).
%   'scatterColor'      : ColorSpec | {'auto'}
%       Scatter marker color for scatter plots of underlying data (if
%       'scatter' is true).
%   'scatterSize'       : Scalar {36}
%       Size, in square points, of the scatter markers (if 'scatter' is
%       true).
%   'style'             : {'normal'} | 'hierarchy'
%       If set to 'hierarchy', additional hierarchical x-axis labels will
%       be added to the plot. The labels can be set using the 'groupLabels'
%       option.
%   'symbolColor'       : ColorSpec | {'auto'}
%       Outlier marker color.
%   'symbolMarker'      : '+' | {'o'} | '*' | '.' | 'x' |
%                         'square' or 's' | 'diamond' or 'd' | '^' | 'v' |
%                         '>' | '<' | 'pentagram' or 'p' | 'hexagram' or
%                         'h' | 'none'
%       Marker used to denote outliers.
%   'xSeparator'        : {false} | true
%       Add a separator line between x groups. Use
%       
%           allLines = findall(gcf,'tag','separator');
%       
%       to return handles to, and hence to modify, the separator lines.
%   'xSpacing'          : {'x'} | 'equal'
%       Determine the x-axis spacing of boxes. By default, the data in x
%       are used to determine the position of boxes on the x-axis (when x
%       is numeric). Alternativley, when set to 'equal', boxes are
%       equally-spaced, but the data in x are used to label the axis; the
%       x-axis ticks are at 1:LENGTH(X).
% 
%   In addition to the above specifications, some options can be specified
%   for each group G. Parameters should be specified as a cell array of
%   size G-by-I-by-J... . These options are: 'boxColor', 'lineColor',
%   'lineStyle', 'lineWidth', 'medianColor', 'notchLineColor',
%   'notchLineStyle', 'outlierSize', 'scatterMarker', 'scatterColor',
%   'scatterSize', 'symbolColor', 'symbolMarker'.
% 
%   Examples
% 
%     Example 1: Basic grouped box plot with legend
% 
%       y = randn(50,3,3);
%       x = [1 2 3.5];
%       y(1:25) = NaN;
% 
%       figure;
%       [~,h] = box_plot(x,y,...
%           'symbolColor','k',...
%           'medianColor','k',...
%           'symbolMarker',{'+','o','d'},...
%           'boxcolor',{[1 0 0]; [0 1 0]; [0 0 1]});
%       box on
%       legend(squeeze(h.boxes(:,1,:)),{'y1','y2','y3'},'location','best')
% 
%     Example 2: Grouped box plot with overlayed data
% 
%       figure;
%       box_plot(x,y,...
%           'symbolColor','k',...
%           'medianColor','k',...
%           'symbolMarker',{'+','o','d'},...
%           'boxcolor','auto',...
%           'scatter',true);
%       box on
% 
%     Example 3: Grouped box plot with displayed sample sizes
%       and variable widths
% 
%       figure;
%       box_plot(x,y,...
%           'medianColor','k',...
%           'symbolMarker',{'+','o','d'},...
%           'boxcolor','auto',...
%           'sampleSize',true,...
%           'scaleWidth',true);
%       box on
% 
%     Example 4: Grouped notched box plot with x separators and
%       hierarchical labels
% 
%       figure;
%       box_plot({'A','B','C'},y,...
%           'notch',true,...
%           'medianColor','k',...
%           'symbolMarker',{'+','o','d'},...
%           'boxcolor','auto',...
%           'style','hierarchy',...
%           'xSeparator',true,...
%           'groupLabels',{{'Group 1','Group 2','Group 3'}});
%       box on
% 
%   See also TAB2BOX, QUANTILE2, BOXPLOT.

%   Copyright 2015 University of Surrey.

% =========================================================================
% Last changed:     $Date: 2015-11-19 09:47:51 +0000 (Thu, 19 Nov 2015) $
% Last committed:   $Revision: 436 $
% Last changed by:  $Author: ch0022 $
% =========================================================================

    %% Initial checks and styles

    % check for input data
    if nargin > 1
        if isnumeric(varargin{2})
            x = varargin{1};
            y = varargin{2};
            if isvector(y) % ensure y is column vector
                y = y(:);
            end
            start = 3;
        else
            y = varargin{1};
            if isvector(y) % ensure y is column vector
                y = y(:);
            end
            x = 1:size(y,2);
            start = 2;
        end
    else
        y = varargin{1};
        if isvector(y) % ensure y is column vector
            y = y(:);
        end
        x = 1:size(y,2);
        start = 1;
    end

    if size(y,1)==1
        error('Boxes are plotted for each column. Each column in the input has only one data point.')
    end
    
    % size of input
    ydims = size(y);
    groupSize = ydims(3:end);
    outdims = ydims; outdims(1) = 1;
    
    % remove NaN columns
    if isnumeric(x)
        x = x(~isnan(x));
        y = y(:,~isnan(x),:);
        y = reshape(y,ydims);
    end

    % default style options
    options = struct(...
        'boxColor','none',...
        'boxAlpha',1,...
        'boxWidth','auto',...
        'groupLabelFontSize',9,...
        'groupLabelHeight','auto',...
        'groupLabels',[],...
        'groupWidth',0.7,...
        'limit','1.5IQR',...
        'lineColor','k',...
        'lineStyle','-',...
        'lineWidth',1,...
        'medianColor','auto',...
        'method','R-8',...
        'notch',false,...
        'notchDepth',0.4,...
        'notchLine',false,...
        'notchLineStyle',':',...
        'notchLineColor','k',...
        'outlierSize',6^2,...
        'sampleFontSize',9,...
        'sampleSize',false,...
        'scaleWidth',false,...
        'scatter',false,...
        'scatterAlpha',1,...
        'scatterColor',[.5 .5 .5],...
        'scatterLayer','top',...
        'scatterMarker','x',...
        'scatterSize',6^2,...
        'style','normal',...
        'symbolColor','auto',...
        'symbolMarker','o',...
        'xSeparator',false,...
        'xSpacing','x');

    % read parameter/value inputs
    if start < nargin % if parameters are specified
        % read the acceptable names
        optionNames = fieldnames(options);
        % count arguments
        nArgs = length(varargin)-start+1;
        if round(nArgs/2)~=nArgs/2
           error('BOX_PLOT needs propertyName/propertyValue pairs')
        end
        % overwrite defults
        for pair = reshape(varargin(start:end),2,[]) % pair is {propName;propValue}
           IX = strcmpi(pair{1},optionNames); % find match parameter names
           if any(IX)
              % do the overwrite
              options.(optionNames{IX}) = pair{2};
           else
              error('%s is not a recognized parameter name',pair{1})
           end
        end
    end

    % check for auto color values and replace with true color
    options.boxColor = checkAutoColor(options.boxColor,groupSize);
    options.lineColor = checkAutoColor(options.lineColor,groupSize);
    options.medianColor = checkAutoColor(options.medianColor,groupSize);
    options.notchLineColor = checkAutoColor(options.notchLineColor,groupSize);
    options.scatterColor = checkAutoColor(options.scatterColor,groupSize);
    options.symbolColor = checkAutoColor(options.symbolColor,groupSize);

    % transform parameters for each group
    boxColor = groupOption(options.boxColor,groupSize,'boxColor');
    lineColor = groupOption(options.lineColor,groupSize,'lineColor');
    lineStyle = groupOption(options.lineStyle,groupSize,'lineStyle');
    lineWidth = groupOption(options.lineWidth,groupSize,'lineWidth');
    medianColor = groupOption(options.medianColor,groupSize,'medianColor');
    notchLineColor = groupOption(options.notchLineColor,groupSize,'notchLineColor');
    notchLineStyle = groupOption(options.notchLineStyle,groupSize,'notchLineStyle');
    outlierSize = groupOption(options.outlierSize,groupSize,'outlierSize');
    scatterMarker = groupOption(options.scatterMarker,groupSize,'scatterMarker');
    scatterColor = groupOption(options.scatterColor,groupSize,'scatterColor');
    scatterSize = groupOption(options.scatterSize,groupSize,'scatterSize');
    symbolColor = groupOption(options.symbolColor,groupSize,'symbolColor');
    symbolMarker = groupOption(options.symbolMarker,groupSize,'symbolMarker');
    
    %% Statistics

    % check x/y data
    assert(isvector(x),'x must be a vector');
    assert(isnumeric(y),'y must be a numeric column vector or matrix');
    assert(numel(x)==size(y,2),'x must have the same number of elements as y has columns')

    % calculate stats
    Z = struct;
    Z.median = quantile2(y,.5,[],options.method); % median
    Z.N = zeros(size(Z.median)); % sample size
    Z.Q1 = zeros(size(Z.median)); % lower quartile
    Z.Q3 = zeros(size(Z.median)); % upper quartile
    Z.IQR = zeros(size(Z.median)); % inter-quartile range
    Z.min = zeros(size(Z.median)); % minimum (excluding outliers)
    Z.max = zeros(size(Z.median)); % maximum (excluding outliers)
    Z.notch_u = zeros(size(Z.median)); % high notch value
    Z.notch_l = zeros(size(Z.median)); % low notch value
    Z.outliers = cell(size(Z.median)); % outliers (defined as more than 1.5 IQRs above/below each quartile)
    Z.outliers_IX = false(size(y)); % outlier logical index
    subidx = cell(1,length(outdims));
    for n = 1:prod(outdims)
        [subidx{:}] = ind2sub(outdims, n);
        subidxAll = subidx;
        subidxLogical = subidx;
        subidxAll{1} = ':';
        [Z.Q1(subidx{:}),Z.N(subidx{:})] = quantile2(y(subidxAll{:}),0.25,[],options.method);
        Z.Q3(subidx{:}) = quantile2(y(subidxAll{:}),0.75,[],options.method);
        Z.IQR(subidx{:}) = Z.Q3(subidx{:})-Z.Q1(subidx{:});
        Z.notch_u(subidx{:}) = Z.median(subidx{:})+(1.58*Z.IQR(subidx{:})/sqrt(Z.N(subidx{:})));
        Z.notch_l(subidx{:}) = Z.median(subidx{:})-(1.58*Z.IQR(subidx{:})/sqrt(Z.N(subidx{:})));
        switch lower(options.limit)
            case '1.5iqr'
                upper_limit = Z.Q3(subidx{:})+1.5*Z.IQR(subidx{:});
                lower_limit = Z.Q1(subidx{:})-1.5*Z.IQR(subidx{:});
            case '3iqr'
                upper_limit = Z.Q3(subidx{:})+3*Z.IQR(subidx{:});
                lower_limit = Z.Q1(subidx{:})-3*Z.IQR(subidx{:});
            case 'none'
                upper_limit = Inf;
                lower_limit = -Inf;
            otherwise
                error('Unknown ''limit'': ''%s''',options.limit)
        end
        Z.outliers_IX(subidxAll{:}) = y(subidxAll{:})>upper_limit | y(subidxAll{:})<lower_limit;
        subidxLogical{1} = ~Z.outliers_IX(subidxAll{:});
        Z.min(subidx{:}) = min(min(y(subidxLogical{:})),Z.Q1(subidx{:})); % min excl. outliers but not greater than lower quartile
        Z.max(subidx{:}) = max(max(y(subidxLogical{:})),Z.Q3(subidx{:})); % max excl. outliers but not less than upper quartile
        subidxLogical{1} = Z.outliers_IX(subidxAll{:});
        Z.outliers{subidx{:}} = y(subidxLogical{:});
    end

    % check for notches extending beyond box
    if (any(Z.notch_u(:)>Z.Q3(:)) || any(Z.notch_l(:)<Z.Q1(:))) && (options.notch || options.notchLine)
        warning('Notch extends beyond quartile. Try setting ''notch'' or ''notchLine'' to false') %#ok<WNTAG>
    end

    %% Plotting

    % calculate positions for groups
    strx = true;
    if isnumeric(x) % x is numeric
        switch lower(options.xSpacing) % choose spacing
            case 'x'
                strx = false;
                diffx = min(diff(x));
                if isempty(diffx)
                    diffx = 1;
                end
                xlabels = [];
            case 'equal'
                xlabels = cellstr(num2str(x));
                x = 1:length(x);
                diffx = 1;
            otherwise
                error('Unknown xSpacing option specified.')
        end
    else % x is not numeric
        xlabels = x;
        x = 1:length(x);
        diffx = 1;
    end
    gRange = options.groupWidth*diffx; % range on x-axis

    % size of boxes
    if ischar(options.boxWidth) || iscell(options.boxWidth)
        if strcmpi(options.boxWidth,'auto') || any(cellfun(@(x)(strcmpi(x,'auto')),options.boxWidth))
            boxwidth =  0.75*(gRange/prod(groupSize));
        else
            error('Unknown boxWidth set.')
        end
    else
        boxwidth = options.boxWidth;
    end
    
    % plot
    h = struct;
    h.axis = gca;
    hold on
    group_x_ticks = zeros(size(Z.median));
    
    % optionally insert x-group separator lines
    if options.xSeparator
        xlines = x(1:end-1)+0.5.*diff(x); % line positions
        hxsl = zeros(size(xlines)); % handles
        for n = 1:length(xlines) % draw lines
            hxsl(n) = line([xlines(n) xlines(n)],get(h.axis,'ylim'),'color',.5+zeros(1,3),'tag','separator');
        end
    end
    
    % min and max sample size
    maxN = max(Z.N(:));
    
    % preallocate indices
    subidx = cell(1,length(outdims));
    
    for n = 1:prod(outdims)
        
        % get indices
        [subidx{:}] = ind2sub(outdims, n);
        subidxAll = [{':'} subidx(2:end)];
        gidx = subidx(3:end);
        
        if options.scaleWidth
            % scale box width according to sample size
            halfboxwidth = 0.5 * (sqrt(Z.N(subidx{:})/maxN)*boxwidth);
        else
            % normal box width
            halfboxwidth = boxwidth/2;
        end
        
        % notch depth
        notchdepth = options.notchDepth*halfboxwidth;
        
        gOffset = get_offset(boxwidth,outdims(3:end),subidx(3:end));

        group_x_ticks(subidx{:}) = x(subidx{2})+gOffset; % determine second axis tick locations
        if options.notch % if notch requested
            % box
            p = patch([x(subidx{2})-halfboxwidth x(subidx{2})-halfboxwidth x(subidx{2})-halfboxwidth+notchdepth x(subidx{2})-halfboxwidth x(subidx{2})-halfboxwidth ...
                x(subidx{2})+halfboxwidth x(subidx{2})+halfboxwidth x(subidx{2})+halfboxwidth-notchdepth x(subidx{2})+halfboxwidth x(subidx{2})+halfboxwidth]+gOffset,...
                [Z.Q1(subidx{:}) Z.notch_l(subidx{:}) Z.median(subidx{:}) Z.notch_u(subidx{:}) Z.Q3(subidx{:}) ...
                Z.Q3(subidx{:}) Z.notch_u(subidx{:}) Z.median(subidx{:}) Z.notch_l(subidx{:}) Z.Q1(subidx{:})],'w','FaceAlpha',options.boxAlpha);
        else
            % box
            p = patch([x(subidx{2})-halfboxwidth x(subidx{2})-halfboxwidth x(subidx{2})+halfboxwidth x(subidx{2})+halfboxwidth]+gOffset,...
                [Z.Q1(subidx{:}) Z.Q3(subidx{:}) Z.Q3(subidx{:}) Z.Q1(subidx{:})],'w','FaceAlpha',options.boxAlpha);
        end
        if options.notchLine % if notchLine requested
            line([x(subidx{2})-halfboxwidth x(subidx{2})+halfboxwidth]+gOffset,[Z.notch_l(subidx{:}) Z.notch_l(subidx{:})],...
                'linestyle',notchLineStyle{gidx{:}},'color',notchLineColor{gidx{:}},...
                'linewidth',lineWidth{gidx{:}})
            line([x(subidx{2})-halfboxwidth x(subidx{2})+halfboxwidth]+gOffset,[Z.notch_u(subidx{:}) Z.notch_u(subidx{:})],...
                'linestyle',notchLineStyle{gidx{:}},'color',notchLineColor{gidx{:}},...
                'linewidth',lineWidth{gidx{:}})
        end

        set(p,'FaceColor',boxColor{gidx{:}},'linewidth',lineWidth{gidx{:}},...
            'EdgeColor',lineColor{gidx{:}})
        % return handles
        h.boxes(subidx{:}) = p;
        % LQ
        line([x(subidx{2}) x(subidx{2})]+gOffset,[Z.min(subidx{:}) Z.Q1(subidx{:})],'linestyle',lineStyle{gidx{:}},...
            'color',lineColor{gidx{:}},'linewidth',lineWidth{gidx{:}})
        % UQ
        line([x(subidx{2}) x(subidx{2})]+gOffset,[Z.max(subidx{:}) Z.Q3(subidx{:})],'linestyle',lineStyle{gidx{:}},...
            'color',lineColor{gidx{:}},'linewidth',lineWidth{gidx{:}})
        % whisker tips
        line([x(subidx{2})-0.5*halfboxwidth x(subidx{2})+0.5*halfboxwidth]+gOffset,[Z.min(subidx{:}) Z.min(subidx{:})],...
            'linestyle','-','color',lineColor{gidx{:}},'linewidth',lineWidth{gidx{:}})
        line([x(subidx{2})-0.5*halfboxwidth x(subidx{2})+0.5*halfboxwidth]+gOffset,[Z.max(subidx{:}) Z.max(subidx{:})],...
            'linestyle','-','color',lineColor{gidx{:}},'linewidth',lineWidth{gidx{:}})
        % outliers
        if ~isempty(Z.outliers)
            xScatter = x(subidx{2}) + gOffset + (0.8.*halfboxwidth.*x_offset(Z.outliers{subidx{:}}));
            h.outliers(subidx{:}) = scatter(xScatter,Z.outliers{subidx{:}},...
                'marker',symbolMarker{gidx{:}},'MarkerEdgeColor',symbolColor{gidx{:}},...
                'SizeData',outlierSize{gidx{:}},'linewidth',lineWidth{gidx{:}});
        end
        % overlay scatter of data
        if options.scatter
            IX = ~Z.outliers_IX(subidxAll{:});
            subidx4 = [{IX} subidx(2:end)];
            % calculate x offsets
            xScatter = x(subidx{2}) + gOffset + (0.8.*halfboxwidth.*x_offset(y(subidx4{:})));
            % plot
            yScatter = y(subidx4{:});
            yScatter = yScatter(~isnan(yScatter));
            h.scatter(subidx{:}) = scatter(xScatter,yScatter,scatterMarker{gidx{:}});
            set(h.scatter(subidx{:}),'SizeData',scatterSize{gidx{:}},'MarkerEdgeColor',scatterColor{gidx{:}});
            if options.scatterAlpha<1
                try % older versions do not support MarkerEdgeAlpha
                    set(h.scatter(subidx{:}),'MarkerEdgeAlpha',options.scatterAlpha);
                catch
                    warning('This version of Matlab does not support scatter marker transparency.')
                end
            end
        end
        % draw median lines
        if options.notch % if notch requested
            % median
            l = line([x(subidx{2})-halfboxwidth+notchdepth x(subidx{2})+halfboxwidth-notchdepth]+gOffset,...
                [Z.median(subidx{:}) Z.median(subidx{:})]);
        else
            % median
            l = line([x(subidx{2})-halfboxwidth x(subidx{2})+halfboxwidth]+gOffset,[Z.median(subidx{:}) Z.median(subidx{:})]);
        end
        set(l,'linestyle','-','linewidth',lineWidth{gidx{:}},'color',medianColor{gidx{:}})
        h.mlines(subidx{:}) = l;
        % show sample size for box
        if options.sampleSize
            xoffset = 0.15*halfboxwidth;
            yoffset = (xoffset./(max(x)-min(x))).*(max(y(:))-min(y(:)));
            % make text
            h.txtsample(subidx{:}) = text(x(subidx{2})+gOffset+halfboxwidth-xoffset,...
                Z.Q3(subidx{:})-yoffset,...
                num2str(sum(~isnan(y(subidxAll{:})))),...
                'horizontalalignment','right','verticalalignment','top',...
                'fontsize',options.sampleFontSize);
        end
    end
    
    %% added extras
    
    % update separator line height
    if options.xSeparator
        set(hxsl,'YData',get(h.axis,'YLim'));
    end

    % set x axis
    set(h.axis,'xtick',x,'xlim',[min(x)-0.5*diffx max(x)+0.5*diffx])
    if strx
        set(h.axis,'xticklabel',xlabels)
    end
    hold off
    
    % change layering of scatter
    switch lower(options.scatterLayer)
        case 'bottom'
            uistack(h.scatter(:),'bottom');
        case 'top'
            % do nothing
        otherwise
            error(['Unknown ''scatterLayer'' option ''' options.scatterLayer ''''])
    end
    
    % final tweaks to plot style
    switch lower(options.style)
        case 'normal'
            % 
        case 'hierarchy'
            
            % check grouplabels options
            if ~isempty(options.groupLabels)
                assert(isvector(options.groupLabels) && iscell(options.groupLabels),...
                    'The GROUPLABELS option should be a cell vector');
                assert(isequal(outdims(3:end),cellfun(@length,options.groupLabels)),...
                    ['The GROUPLABELS option should be a cell vector; ' ...
                    'the Nth element should contain a vector of length SIZE(Y,N+2)'])
            end
            
            % number of label rows
            labelrows = length(outdims)-1;
            
            ylim = get(gca,'ylim'); % need y limitis
            
            if isnumeric(options.groupLabelHeight)
                labelheight = options.groupLabelHeight;
            else
                % determine label height
                assert(strcmpi(options.groupLabelHeight,'auto'),'Unknow ''groupLabelHeight'' setting')
                labelheight = calc_label_height(h.axis); % y range in units calculated based on normalised height
            end
            
            % determine y centre points of labels based on how many labels
            % and their height
            ymids = ylim(1) - (labelrows:-1:1).*labelheight + 0.5.*labelheight;
            
            % clear axis tick labels
            set(gca,'xticklabels',[]);
            
            % put labels on plot
            totalticks = prod(outdims(2:end)); % total number of ticks across
            allticklocs = sort(group_x_ticks(:)); % their locations
            h.txtg = [];
            for c = labelrows:-1:1 % work down hierarchy
                Y = ymids(c); % y location
                nskip = totalticks/prod(outdims(2:c+1)); % skip through tick locations based on hierarchy
                first = 1:nskip:totalticks; % first tick in group
                last = nskip:nskip:totalticks; % last tick in group
                labellocs = allticklocs(first) + 0.5.*(allticklocs(last)-allticklocs(first)); % centre point for label location
                % work through each label location
                for n = 1:length(labellocs)
                    if c==1 % special case: x axis ticks
                        if strx
                            gLabel = xlabels{n};
                        else
                            gLabel = num2str(x(n));
                        end
                    else % every other group
                        if isempty(options.groupLabels) % auto increment label
                            gLabel = num2str(mod(n-1,outdims(c+1))+1);
                        else % get from input
                            gLabel = options.groupLabels{c-1}(mod(n-1,outdims(c+1))+1); % cyclic index into labels
                            if isnumeric(gLabel) % convert numbers to strings
                                gLabel = num2str(gLabel);
                            end
                        end
                    end
                    % place actual label
                    t = text(labellocs(n),Y,gLabel,'HorizontalAlignment','center','VerticalAlignment','middle');
                    % store info about placement
                    setappdata(t,'rows',labelrows);
                    setappdata(t,'row',c);
                    % add to handles
                    h.txtg = [h.txtg t];
                end
                
            end

        otherwise
            error('Unkown ''style'' option.')
    end
    
    if isfield(h,'txtg')
        set(h.txtg,'FontSize',options.groupLabelFontSize);
    end

    % get handle to parent figure
    setappdata(handle(h.axis),'ParentFig',gcf)
    
    % add listener to ylim to change line length
    addlistener(handle(h.axis),{'YLim'},'PostSet',...
        @(hProp,eventData) eventHandler(h,hProp,eventData));
    
    % only return output if requested
    if nargout>0
        z=Z;
    end

end
    
function out = groupOption(option,groupSize,name)
%GROUPOPTION convert parameter to format for plotting
    
    if length(groupSize)==1
        groupSize = [groupSize 1];
    end
        
    % checks
    if ischar(option)
        option = cellstr(option); % ensure string is cell array
    elseif isnumeric(option)
        option = {option};
    end
    if isvector(option)
        option = option(:);
    end

    % pre-allocate output
    out = cell(groupSize);

    % create output
    if length(option)==1 % repeat if only one specified
        for n = 1:prod(groupSize)
            out(n) = option;
        end
    elseif isequal(groupSize,size(option)) % put into cell array
        for n = 1:prod(groupSize)
            assert(ischar(option{n}) || size(option{n},2)==3,['Option ''' name ''' is not in the correct format.'])
            out(n) = option(n);
        end
    else
        error('Option ''%s'' is not the correct size.',name)
    end

end

function out = checkAutoColor(color,groupSize)
%CHECKAUTOCOLOR convert 'auto' color option to RGB

    out = color; % pass input to output unless...

    if ischar(color) % 'auto'
        if strcmpi(color,'auto')
            out = cell([groupSize 1]); % default colormap
            templines = lines(prod(groupSize));
            for n = 1:prod(groupSize)
                out{n} = templines(n,:);
            end
        end
    end

end

function offset = x_offset(y)
%X_OFFSET create an x offset based on data distribution

    y = y(~isnan(y));
    [N,~,bin] = histcounts(y); % create a histogram
    xShaping = (N(bin)-1)./max(1,max(N-1));
    offset = ((2.*rand(length(y),1))-1).*xShaping(:);

end

function offset = get_offset(boxwidth,dims,subidx)
%GET_OFFSET calculate offset for hierarchical data

    if isempty(dims) || prod(dims)==1
        offset = 0;
    else
        boxspacing = boxwidth./0.75;
        offsetn = (0:prod(dims)-1)-((prod(dims)-1)./2);
        n = sub2ind([dims(end:-1:1) 1],subidx{end:-1:1});
        offset = offsetn(n).*boxspacing;
    end

end

function labelheight = calc_label_height(h)
%CALC_LABEL_HEIGHT calculate the label height for the axes

    ylim = get(h,'ylim');
    plotheight = get(h,'position'); % plot position
    plotheight = plotheight(4); % plot height in normalised units
    plotrange = abs(diff(ylim)); % y range
    labelheight = plotheight*plotrange*0.05; % y range in units calculated based on normalised height
    
end

function eventHandler(h,hProp,eventData)
%EVENTHANDLER handle axes property change events

    propName = hProp.Name;
    propValue = eventData.AffectedObject.(propName);
    fig = getappdata(handle(h.axis),'ParentFig'); % parent figure handle
    
    % update separator lines
    lh = findall(fig,'tag','separator');
    if strcmpi(propName,'YLim')
        % correct x separator limits
        if ~isempty(lh)
            set(lh,'YData',propValue)
        end
        % move group labels up or down
        if isfield(h,'txtg')
            labelheight = calc_label_height(h.axis);
            for n = 1:length(h.txtg)
                % current position
                pos = get(h.txtg(n),'Position');
                % new position
                rows = getappdata(h.txtg(n),'rows');
                row = getappdata(h.txtg(n),'row');
                pos(2) = propValue(1) - (rows-row+.5)*labelheight;
                % set it
                set(h.txtg(n),'Position',pos)
            end
        end
    end
   
end
