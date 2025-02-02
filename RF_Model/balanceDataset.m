function [balancedFeatures, balancedLabels] = balanceDataset(features, labels)
    [uniqueLabels, ~, labelIdx] = unique(labels);
    counts = accumarray(labelIdx, 1);
    minCount = min(counts);
    
    balancedFeatures = [];
    balancedLabels = [];
    
    for i = 1:length(uniqueLabels)
        classMask = (labels == uniqueLabels(i));
        classFeatures = features(classMask, :);
        
        if size(classFeatures, 1) > minCount
            idx = randperm(size(classFeatures, 1), minCount);
            classFeatures = classFeatures(idx, :);
        end
        
        balancedFeatures = [balancedFeatures; classFeatures];
        balancedLabels = [balancedLabels; repmat(uniqueLabels(i), size(classFeatures, 1), 1)];
    end
    
    idx = randperm(size(balancedFeatures, 1));
    balancedFeatures = balancedFeatures(idx, :);
    balancedLabels = balancedLabels(idx);
end