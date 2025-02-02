function model = trainModel(features, labels)
    kernels = {'linear','rbf','polynomial'};
    C_values = [1, 3, 5];
    params.KernelScale = 'auto';
    params.Standardize = true;

    k = 5;
    cvp = cvpartition(length(labels), 'KFold', k);
    bestAcc = 0;
    bestParams = params;

    for kIdx = 1:length(kernels)
        for cIdx = 1:length(C_values)
            params.KernelFunction = kernels{kIdx};
            params.BoxConstraint = C_values(cIdx);
            accuracies = zeros(k,1);
            for fold = 1:k
                trainIdx = training(cvp, fold);
                validIdx = test(cvp, fold);
                foldModel = fitcsvm(features(trainIdx,:), labels(trainIdx),...
                    'KernelFunction', params.KernelFunction, ...
                    'BoxConstraint', params.BoxConstraint, ...
                    'KernelScale', params.KernelScale, ...
                    'Standardize', params.Standardize);
                preds = predict(foldModel, features(validIdx,:));
                accuracies(fold) = sum(preds == labels(validIdx)) / numel(preds);
            end
            meanAcc = mean(accuracies);
            fprintf('\nKernel: %s, C: %.1f, Accuracy: %.4f', params.KernelFunction, params.BoxConstraint, meanAcc);
            if meanAcc > bestAcc
                bestAcc = meanAcc;
                bestParams = params;
            end
        end
    end
    fprintf('\n\nBest Parameters: Kernel: %s, C: %.1f, Accuracy: %.4f\n', bestParams.KernelFunction, bestParams.BoxConstraint, bestAcc);

    model = fitcsvm(features, labels, ...
        'KernelFunction', bestParams.KernelFunction, ...
        'BoxConstraint', bestParams.BoxConstraint, ...
        'KernelScale', bestParams.KernelScale, ...
        'Standardize', bestParams.Standardize);
end
