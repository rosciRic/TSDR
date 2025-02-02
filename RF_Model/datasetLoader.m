function [images, labels] = datasetLoader(csvPath, imageFolder)


data = readtable(csvPath);
numImages = size(data, 1);

images = cell(numImages, 1);
labels = data.ClassId;

for i = 1:numImages
    imgPath = fullfile(imageFolder, data.Path{i});
    images{i} = imread(imgPath);
end
end
