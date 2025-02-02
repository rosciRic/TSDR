function [trainData, testData] = prepareTrainTest(features, labels, holdoutRatio)
    cv = cvpartition(labels, 'HoldOut', holdoutRatio, 'Stratify', true);
    trainData.features = features(training(cv),:);
    trainData.labels = labels(training(cv));
    testData.features = features(test(cv),:);
    testData.labels = labels(test(cv));
end