load("../data/processed/results.mat", results);
%%
model = results.Model;
roiImagePath = './SegmentedROIs/ROI_2_triangle.png';
metaFolderPath = '../data/raw/Meta';
roiImage = imread(roiImagePath);
features = extractFeatures(roiImage);
%%
predictedLabel = predict(model, features);
predictedLabel = num2str(cell2mat(predictedLabel));
metaImagePath = fullfile(metaFolderPath, strcat(predictedLabel, '.png'));
metaImage = imread(metaImagePath);

figure('Name', 'Risultati Riconoscimento Cartello');
subplot(1, 2, 1);
imshow(roiImage);
title('ROI Estratta');

subplot(1, 2, 2);
imshow(metaImage);
title('Cartello Predetto');