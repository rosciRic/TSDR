function metrics = evaluateModel(model, testData)
    predictedLabels = predict(model, testData.features);
    trueLabels = testData.labels;
    accuracy = sum(predictedLabels == trueLabels) / numel(trueLabels);
    fprintf('\nAccuracy: %.2f%%\n', accuracy*100);
    
    trueCat = categorical(trueLabels);
    predCat = categorical(predictedLabels);
    classNames = categories(trueCat);
    numClasses = numel(classNames);
    confMat = confusionmat(trueCat, predCat);
    
    TP = zeros(numClasses,1);
    FP = zeros(numClasses,1);
    FN = zeros(numClasses,1);
    TN = zeros(numClasses,1);
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
        'Accuracy', accuracy, ...
        'MacroPrecision', mean(precision, 'omitnan'), ...
        'MacroRecall', mean(recall, 'omitnan'), ...
        'MacroF1', mean(f1, 'omitnan'), ...
        'MacroSpecificity', mean(specificity, 'omitnan'), ...
        'MicroPrecision', sum(TP) / (sum(TP)+sum(FP)), ...
        'MicroRecall', sum(TP) / (sum(TP)+sum(FN)), ...
        'ClassWise', table(precision, recall, f1, specificity, 'RowNames', classNames));
    
    confMatNorm = confMat ./ sum(confMat,2);
    figure('Position',[100 100 1200 500]);
    heatmap(classNames, classNames, confMatNorm, 'Colormap', parula, 'ColorLimits', [0 1], 'Title', 'Normalized Confusion Matrix');
    figure;
    confusionchart(trueCat, predCat);
    title('Confusion Matrix');
end
