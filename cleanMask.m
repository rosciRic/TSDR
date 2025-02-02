function mask = cleanMask(mask)
mask = imfill(mask, 'holes');
mask = bwareaopen(mask, 100);
end
