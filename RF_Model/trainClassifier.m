function [model, optimalNumTrees] = trainClassifier(features, labels)

maxTrees = 750;
batchSize = 50;
toleranceWindow = 3;
errorThreshold = 0.001;


model = TreeBagger(batchSize, features, labels, ...
    'OOBPrediction', 'on', 'MinLeafSize', 5);

numIterations = ceil(maxTrees / batchSize);
oobErrors = NaN(numIterations, 1);
oobErrors(1) = oobError(model, 'Mode', 'Ensemble');

optimalNumTrees = batchSize;


for iter = 2:numIterations
    model = growTrees(model, batchSize);


    currentError = oobError(model, 'Mode', 'Ensemble');
    oobErrors(iter) = currentError(end);


    if iter > toleranceWindow
        windowErrors = oobErrors((iter-toleranceWindow+1):iter);
        if range(windowErrors) < errorThreshold
            optimalNumTrees = iter * batchSize;
            fprintf('Convergenza raggiunta a %d alberi\n', optimalNumTrees);
            break;
        end
    end


    plotTrainingProgress(oobErrors(1:iter), batchSize);

end


if optimalNumTrees < maxTrees
    model = TreeBagger(optimalNumTrees, features, labels, ...
        'OOBPrediction', 'on', 'MinLeafSize', 5);
end

end


function plotTrainingProgress(errors, batchSize)
figure(1);
plot((1:length(errors)) * batchSize, errors, 'b-o');
xlabel('Numero di Alberi');
ylabel('Errore OOB');
title(sprintf('Progresso Addestramento (Batch: %d)', batchSize));
grid on;
drawnow;
end
