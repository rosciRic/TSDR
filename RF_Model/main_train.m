clc
clear
%%
config = struct();
config.paths.raw = '../data/raw/';
config.paths.processed = '../data/processed/';
config.paths.models = '../model/';
config.files.train = 'Train.csv';
config.files.test = 'Test.csv';
config.files.meta = 'Meta.csv';
config.imageSize = [40, 40];

%% Caricamento dati e preprocessing
metaData = readtable(fullfile(config.paths.raw, config.files.meta));
classNames = categories(categorical(metaData.ClassId));

[trainImages, trainLabels_full] = datasetLoader(...
    fullfile(config.paths.raw, config.files.train), ...
    config.paths.raw);

[trainFeatures, trainLabels_full] = extractFeatures(trainImages, trainLabels_full);
[trainFeatures, trainLabels] = balanceDataset(trainFeatures, trainLabels_full);

%% Addestramento modello con early stopping

trainStart = tic;
[model, optimalTrees] = trainClassifier(trainFeatures, trainLabels);
trainTime = toc(trainStart);
fprintf('\nAddestramento completato in %.2f minuti\n', trainTime/60);
fprintf('Numero ottimale di alberi: %d\n', optimalTrees);

%Results
% Convergenza raggiunta a 400 alberi
% 
% Addestramento completato in 2.41 minuti
% Numero ottimale di alberi: 400

%% Caricamento e processing test set
[testImages, testLabels_unb] = datasetLoader(...
    fullfile(config.paths.raw, config.files.test), ...
    config.paths.raw);

[testFeatures, testLabels_unb] = extractFeatures(testImages, testLabels_unb);
[testFeatures, testLabels] = balanceDataset(testFeatures, testLabels_unb);
%% Predizione e valutazione
predictionStart = tic;
predictedLabels = predict(model, testFeatures);
predictionTime = toc(predictionStart);
fprintf('\nPredizione completata in %.2f secondi\n', predictionTime);

% Predizione completata in 2.52 secondi

%% Valutazione avanzata con visualizzazioni
testMetrics = evaluateModel(predictedLabels, testLabels, classNames);

%% Visualizzazione risultati chiave
fprintf('\n=== Risultati Finali ===\n');
fprintf('Accuracy: %.2f%%\n', testMetrics.Accuracy*100);
fprintf('Macro F1-score: %.2f\n', testMetrics.MacroF1);
figure;
confusionchart(testLabels, str2double(predictedLabels));
% === Risultati Finali ===
% Accuracy: 92.94%
% Macro F1-score: 0.93
%% Salvataggio risultati
results = struct(...
    'Model', model,...
    'Metrics', testMetrics,...
    'TrainTime', trainTime,...
    'PredictionTime', predictionTime);

save(fullfile('..', 'modelloRF.mat'), 'model');
