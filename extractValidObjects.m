function [validObjects, validMask, rgbROIs] = extractValidObjects(mask, img)
[L, num] = bwlabel(mask);
stats = regionprops(L, 'BoundingBox', 'Image', 'Circularity', 'Area');
imgArea = numel(mask);

validMask = false(num, 1);
rgbROIs = cell(num, 1);

for i = 1:num
    bb = stats(i).BoundingBox;
    aspectRatio = bb(3) / bb(4);
    areaRatio = stats(i).Area / imgArea;

    if aspectRatio >= 1/1.9 && aspectRatio <= 1.9 && ...
            areaRatio > 0.001 && areaRatio < 0.3
        validMask(i) = true;
        rgbROIs{i} = imcrop(img, bb);
    end
end

validObjects = stats(validMask);
rgbROIs = rgbROIs(validMask);
end