function [images, labels] = loadDataset(config)
    data = readtable(config.dataset.csvPath, 'TextType', 'string');
    validClasses = ismember(data.ClassId, [config.dataset.circleClasses, config.dataset.triangleClasses]);
    data = data(validClasses, :);
    
    numImages = height(data);
    images = cell(numImages,1);
    labels = categorical(zeros(numImages,1), [0 1], {'circle','triangle'});
    
    parfor i = 1:numImages
        try
            imgPath = fullfile(config.dataset.imageFolder, data.Path{i});
            images{i} = imread(imgPath);
            if ismember(data.ClassId(i), config.dataset.circleClasses)
                labels(i) = 'circle';
            else
                labels(i) = 'triangle';
            end
        catch
            images{i} = [];
        end
    end
    validIdx = ~cellfun(@isempty, images);
    images = images(validIdx);
    labels = labels(validIdx);
end
