function [predictions, scores] = classifyObjects(objects, model, config)
    numObjects = numel(objects);
    features = zeros(numObjects, 8);
    
    for i = 1:numObjects
        features(i, :) = extractHuFeatures(objects(i));
    end
    
    [~, allScores] = predict(model, features);
    predictions = categorical(zeros(numObjects, 1));
    scores = zeros(numObjects, 1);
    
    for i = 1:numObjects
        [maxScore, maxIdx] = max(allScores(i, :));
        if maxScore >= config.scoreThreshold
            predictions(i) = categorical(config.classes(maxIdx));
            scores(i) = maxScore;
        else
            predictions(i) = categorical({'Non classificato'});
            scores(i) = maxScore;
        end
    end
end