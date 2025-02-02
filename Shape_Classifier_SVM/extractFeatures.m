function [features, validLabels] = extractFeatures(images, labels)
    numImages = numel(images);
    features = zeros(numImages, 8);
    
    parfor i = 1:numImages
        try
            hu = invmoments(images{i});
            stats = regionprops(logical(images{i}), 'Circularity');
            if isempty(stats)
                circ = 0;
            else
                circ = stats(1).Circularity;
            end
            features(i,:) = [hu, circ];
        catch
            features(i,:) = NaN(1,8);
        end
    end
    validIdx = ~any(isnan(features),2);
    features = features(validIdx,:);
    validLabels = labels(validIdx);
    
    classes = categories(validLabels);
    if numel(classes) >= 2
        idx1 = find(validLabels == classes{1});
        idx2 = find(validLabels == classes{2});
        minCount = min(numel(idx1), numel(idx2));
        idx1 = idx1(randperm(numel(idx1), minCount));
        idx2 = idx2(randperm(numel(idx2), minCount));
        allIdx = [idx1; idx2];
        shuffleIdx = randperm(length(allIdx));
        features = features(allIdx(shuffleIdx),:);
        validLabels = validLabels(allIdx(shuffleIdx));
    end
end
