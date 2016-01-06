load('C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results\od-down\results.mat');
originalAUC = results.auc;
if (isfield(results, 'tnr'))
    plot(1-results.tnr, results.tpr)
else
    plot(1-results.fpr, results.tpr)
end
xlabel('1 - Specificity (FPR)');
ylabel('Sensitivity (TPR)');
title('ROC curve obtained from logit scores');
hold on

load('C:\Users\USUARIO\Dropbox\RetinalImaging\Writing\cnn2015paper\results\od-down-aug\results.mat');
newAUC = results.auc;
plot(1-results.tnr, results.tpr)

guessline = 0:1/length(results.tpr):1;
plot(guessline, guessline);

legend(strcat('Original images - AUC=', num2str(originalAUC)), strcat('Original images - Augmented - AUC=', num2str(newAUC)), 'Ineffective');
