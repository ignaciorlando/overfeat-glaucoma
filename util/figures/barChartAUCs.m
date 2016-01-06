
load('G:\Dropbox\RetinalImaging\Writing\cnn2015paper\results\averageAUCs.mat');
savePath = 'G:\Dropbox\RetinalImaging\Writing\cnn2015paper\paper\figures\bar';

inpainted = false;

if (inpainted)
    L1 = averageAUCs{2};
    L1_std = stdevsAUCs{2};
    L2 = averageAUCs{4};
    L2_std = stdevsAUCs{4};
else
    L1 = averageAUCs{1};
    L1_std = stdevsAUCs{1};
    L2 = averageAUCs{3};
    L2_std = stdevsAUCs{3};
end

zoomNames = {'Original image', 'Cropped FOV', 'Peripapillary Area', 'ONH'};
zoomNamesFiles = {'OriginalImage', 'CroppedFOV', 'PeripapillaryArea', 'ONH'};

lims_axis = [0.5 0.8];
maxValue = max([L1, L2]);
numtrials = 200;

% For each zoom type
first_point = 1;
increment = 6;
for i = 1 : length(zoomNames)
    
    fig = figure('Position', [100, 100, 400, 300]);
    hold off;
    
    h = subplot(1,2,1);
    box on
    subL1 = L1(first_point : first_point + increment - 1);    
    subL1_std = L1_std(first_point : first_point + increment - 1);  
    subL1_reshaped = reshape(subL1, length(subL1) / 2, 2)';
    subL1_std_reshaped = reshape(subL1_std, length(subL1_std) / 2, 2)';
    neworder = {{'Original', 'CLAHE'}, subL1_reshaped};
    barweb([neworder{:,2}], subL1_std_reshaped / sqrt(numtrials), [], [], [], [], [], [], colormap, [], 2, [])
    %bar([neworder{:,2}])
    ylim(lims_axis);
    hline = refline([0 maxValue]);
    hline.Color = 'b';
    set(gca,'XTickLabel',neworder{:,1})
    set(gca,'YTick',[0.4:0.05:0.85]) 
    grid(gca,'on');
    title('L1');
    
    
    h = subplot(1,2,2);
    box on
    subL1 = L2(first_point : first_point + increment - 1);    
    subL1_std = L2_std(first_point : first_point + increment - 1);  
    subL1_reshaped = reshape(subL1, length(subL1) / 2, 2)';
    subL1_std_reshaped = reshape(subL1_std, length(subL1_std) / 2, 2)';
    neworder = {{'Original', 'CLAHE'}, subL1_reshaped};
    barweb([neworder{:,2}], subL1_std_reshaped / sqrt(numtrials), [], [], [], [], [], [], colormap, [], 2, [])
    %bar([neworder{:,2}])
    ylim(lims_axis);
    hline = refline([0 maxValue]);
    hline.Color = 'b';
    set(gca,'XTickLabel',neworder{:,1})
    set(gca,'YTick',[0.4:0.05:0.85]) 
    grid(gca,'on');
    title('L2');
    if (i==length(zoomNames))
        legend('Not aug.','Aug. 90º','Aug. 45º', 'Location', 'southeast');
    end
    
    set(gcf,'NextPlot','add');
    axes;
    p = suptitle(zoomNames{i});
    set(gca,'Visible','off');
    set(p,'Visible','on');
    
    set(fig,'Units','Inches');
    pos = get(fig,'Position');
    set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    if (inpainted)
        print(fig,strcat(savePath, filesep, zoomNamesFiles{i}, '-inpainted'),'-dpdf','-r0');
        savefig(strcat(savePath, filesep, zoomNamesFiles{i}, '-inpainted'));
    else
        print(fig,strcat(savePath, filesep, zoomNamesFiles{i}),'-dpdf','-r0')
        savefig(strcat(savePath, filesep, zoomNamesFiles{i}));
    end
    
    first_point = first_point + increment;
end

close all