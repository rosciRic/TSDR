function metrics = evaluateModel(predictedLabels, trueLabels, classNames)

trueLabels = categorical(trueLabels);
    predictedLabels = categorical(predictedLabels);
    
    confMat = confusionmat(trueLabels, predictedLabels, 'Order', classNames);
    
    numClasses = length(classNames);
    [TP, FP, FN, TN] = deal(zeros(numClasses, 1));
    
    for i = 1:numClasses
        TP(i) = confMat(i,i);
        FP(i) = sum(confMat(:,i)) - TP(i);
        FN(i) = sum(confMat(i,:)) - TP(i);
        TN(i) = sum(confMat(:)) - TP(i) - FP(i) - FN(i);
    end
    
    precision = TP ./ (TP + FP);
    recall = TP ./ (TP + FN);
    f1 = 2 * (precision .* recall) ./ (precision + recall);
    specificity = TN ./ (TN + FP);
    
    metrics = struct(...
        'Accuracy', sum(TP)/sum(confMat(:)),...
        'MacroPrecision', mean(precision, 'omitnan'),...
        'MacroRecall', mean(recall, 'omitnan'),...
        'MacroF1', mean(f1, 'omitnan'),...
        'MacroSpecificity', mean(specificity, 'omitnan'),...
        'MicroPrecision', sum(TP)/(sum(TP)+sum(FP)),...
        'MicroRecall', sum(TP)/(sum(TP)+sum(FN)),...
        'ClassWise', table(precision, recall, f1, specificity, 'RowNames', classNames));
    
    figure('Position', [100 100 1200 500]);
    
    confMatNormalized = confMat ./ sum(confMat,2);
    heatmap(classNames, classNames, confMatNormalized,...
        'Colormap', parula,...
        'ColorLimits', [0 1],...
        'Title', 'Matrice di Confusione Normalizzata');
end
