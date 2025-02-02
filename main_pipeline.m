%% Pulizia workspace e configurazione
clc; clear; close all;

%% Parametri e percorsi
inputImagePath = './TestImages/test1.png';
svmModelPath = './modelloSVM.mat';
rfModelPath = './modelloRF.mat';
metaFolderPath = '../data/raw/Meta';

%% 1. Caricamento immagine e modelli
fprintf('1. Caricamento dati...\n');
img = imread(inputImagePath);
load(svmModelPath, 'model');
svmModel = model;
rfModel = load(rfModelPath).rfModel;
config = initConfig();

figure('Name', '1. Immagine Originale');
imshow(img);
title('Immagine Input');
pause(1);

%% 2. Conversione in HSI e segmentazione colore
fprintf('2. Segmentazione colore...\n');
hsiImg = rgb2hsi(img);
H = hsiImg(:,:,1)*360;
S = hsiImg(:,:,2)*255;
I = hsiImg(:,:,3)*255;

%% 3. Creazione e pulizia maschera
fprintf('3. Creazione maschera...\n');
mask = createColorMask(H, S, I);
cleanedMask = cleanMask(mask);

figure();
imshow(mask);
title('Maschera Originale');

figure()
imshow(cleanedMask);
title('Maschera Pulita');
pause(1);

%% 4. Estrazione ROI
fprintf('4. Estrazione ROI...\n');
[objects, validMask, rgbROIs] = extractValidObjects(cleanedMask, img);

if isempty(objects)
    error('Nessun oggetto valido trovato nell''immagine');
end

figure('Name', '4. Oggetti Rilevati');
imshow(img);
hold on;
for i = 1:numel(objects)
    bb = objects(i).BoundingBox;
    rectangle('Position', bb, 'EdgeColor', 'g', 'LineWidth', 2);
end
title('Oggetti Rilevati');
hold off;
pause(1);

%% 5. Classificazione forme con SVM
fprintf('5. Classificazione forme...\n');
[shapePredict, scores] = classifyObjects(objects, svmModel, config);

validROIs = {};
validPredictions = {};
validScores = [];

for i = 1:numel(shapePredict)
    if ~strcmp(char(shapePredict(i)), 'Non classificato')
        validROIs{end+1} = rgbROIs{i}; 
        validPredictions{end+1} = shapePredict(i); 
        validScores(end+1) = scores(i); 
    end
end

figure('Name', '5. Classificazione Forme');
imshow(img);
hold on;

for i = 1:numel(objects)
    bb = objects(i).BoundingBox;
    className = char(shapePredict(i));
    
    if strcmp(className, 'Cerchio')
        color = [1 0 0];
    elseif strcmp(className, 'Triangolo')
        color = [0 1 0];
    else
        color = [0 0 0];
    end
    
   
    if ~strcmp(className, 'Non classificato')
        rectangle('Position', bb, 'EdgeColor', color, 'LineWidth', 2);
        text(bb(1), bb(2)-10, sprintf('%s (%.2f)', className, scores(i)), ...
            'Color', color, 'FontSize', 8, 'FontWeight', 'bold');
    end
end

title('Rilevamento Forme');
hold off;

figure()
if ~isempty(validROIs)
    montage(validROIs, 'Size', [1 numel(validROIs)]);
    title('ROI Estratte');
else
    text(0.5, 0.5, 'Nessuna ROI trovata', 'HorizontalAlignment', 'center');
end
pause(1);

%% 6. Classificazione cartelli con Random Forest
fprintf('6. Classificazione cartelli...\n');
numValidROIs = length(validROIs);
figure('Name', '6. Classificazione Finale');

for i = 1:numValidROIs
    % Estrai features e classifica
    features = extractFeatures(validROIs{i});
    predictedLabel = predict(rfModel, features);
    predictedLabel = num2str(cell2mat(predictedLabel));
    
    % Carica immagine meta corrispondente
    metaImagePath = fullfile(metaFolderPath, strcat(predictedLabel, '.png'));
    
    if isfile(metaImagePath)
        metaImage = imread(metaImagePath);
        
        % Visualizza ROI e cartello corrispondente
        subplot(2, numValidROIs, i);
        imshow(validROIs{i});
        title(sprintf('ROI %d', i));
        
        subplot(2, numValidROIs, i + numValidROIs);
        imshow(metaImage);
        title(sprintf('Cartello %s', predictedLabel));
    else
        fprintf('Immagine meta non trovata per label %s\n', predictedLabel);
    end
end

%% 7. Report finale
fprintf('\n=== Report Finale ===\n');
fprintf('Oggetti trovati: %d\n', numValidROIs);
for i = 1:numValidROIs
    fprintf('Oggetto %d:\n', i);
    fprintf('  - Forma: %s (score: %.2f)\n', char(validPredictions{i}), validScores(i));
    features = extractFeatures(validROIs{i});
    predictedLabel = predict(rfModel, features);
    fprintf('  - Tipo cartello: %s\n', char(predictedLabel));
end
