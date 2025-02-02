clear; clc; close all;

config = initializeConfig();

[images, labels] = loadDataset(config);
fprintf('\nLoaded dataset: %d images\n', numel(images));
%%
[procImages, procLabels] = preprocessImages(images, labels);
fprintf('Preprocessed images: %d\n', numel(procImages));

[features, procLabels] = extractFeatures(procImages, procLabels);
[trainData, testData] = prepareTrainTest(features, procLabels, config.dataset.holdoutRatio);
%%
model = trainModel(trainData.features, trainData.labels);
saveModel(model, 'modelloSVM.mat');

metrics = evaluateModel(model, testData);


% Loaded dataset: 35609 images
% Preprocessed images: 18783
% 
% Kernel: linear, C: 1.0
% Accuratezza: 0.9032 (±0.0062)
% 
% Kernel: linear, C: 3.0
% Accuratezza: 0.9032 (±0.0062)
% 
% Kernel: linear, C: 5.0
% Accuratezza: 0.9034 (±0.0063)
% 
% Kernel: rbf, C: 1.0
% Accuratezza: 0.9431 (±0.0040)
% 
% Kernel: rbf, C: 3.0
% Accuratezza: 0.9435 (±0.0057)
% 
% Kernel: rbf, C: 5.0
% Accuratezza: 0.9429 (±0.0073)
% 
% Kernel: polynomial, C: 1.0
% Accuratezza: 0.9386 (±0.0059)
% 
% Kernel: polynomial, C: 3.0
% Accuratezza: 0.9243 (±0.0137)
% 
% Kernel: polynomial, C: 5.0
% Accuratezza: 0.9219 (±0.0119)
% 
% MIGLIORI PARAMETRI TROVATI:
% Kernel Function: rbf
% BoxConstraint: 3.0
% Accuratezza: 0.9435

%Test data
% Accuracy: 94.78%









