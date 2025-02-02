function roi = processImage(img)
    hsiImg = rgb2hsi(img);
    H = hsiImg(:,:,1)*360;
    S = hsiImg(:,:,2)*255;
    I = hsiImg(:,:,3)*255;
    
    redMask = ((H >= 0 & H <= 10) | (H >= 300 & H <= 360)) & (S >= 25 & S <= 250) & (I >= 30 & I <= 200);
    blueMask = (H >= 190 & H <= 260) & (S >= 70 & S <= 250) & (I >= 56 & I <= 128);
    combinedMask = redMask | blueMask;
    
    procMask = imfill(combinedMask, 'holes');
    procMask = bwareaopen(procMask, 100);
    
    [L, num] = bwlabel(procMask);
    if num == 0
        roi = [];
        return;
    end
    stats = regionprops(L, 'BoundingBox', 'Image');
    roi = [];
    for i = 1:numel(stats)
        bb = stats(i).BoundingBox;
        aspectRatio = bb(3) / bb(4);
        if aspectRatio >= 1/1.9 && aspectRatio <= 1.9
            roi = stats(i).Image;
            break;
        end
    end
end
