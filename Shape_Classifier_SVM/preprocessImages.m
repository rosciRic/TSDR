function [procImages, procLabels] = preprocessImages(images, labels)
    numImages = numel(images);
    procImages = cell(numImages,1);
    parfor i = 1:numImages
        try
            procImages{i} = processImage(images{i});
        catch
            procImages{i} = [];
        end
    end
    validIdx = ~cellfun(@isempty, procImages);
    procImages = procImages(validIdx);
    procLabels = labels(validIdx);
end
