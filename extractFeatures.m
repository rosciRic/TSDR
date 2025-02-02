function features = extractFeatures(img)

features = [];
resizedImg = imresize(img, [40 40]);

hsiImg = rgb2hsi(resizedImg);

hogFeatures = [];
for channel = 1:3
    channelHog = extractHOGFeatures(hsiImg(:,:,channel), ...
        'BlockSize', [8 8], ...
        'BlockOverlap', [4 4], ...
        'CellSize', [5 5], ...
        'NumBins', 9);
    hogFeatures = [hogFeatures, channelHog];
end

grayImg = rgb2gray(resizedImg);
lssFeatures = extractLSSFeatures(grayImg);

featureVector = [hogFeatures, lssFeatures];

features = [features; featureVector];
end


function lssFeatures = extractLSSFeatures(img)

patchSize = 3;
windowRadius = 10;
numAngles = 20;
numRadii = 4;

img = double(img);
[h, w] = size(img);

centerY = floor(h/2);
centerX = floor(w/2);
centerPatch = img(centerY-floor(patchSize/2):centerY+floor(patchSize/2), ...
    centerX-floor(patchSize/2):centerX+floor(patchSize/2));

padSize = floor(patchSize/2);
paddedImg = padarray(img, [padSize padSize], 'symmetric');

corrSurface = normxcorr2(centerPatch, paddedImg);
corrSurface = corrSurface(patchSize:end-patchSize+1, patchSize:end-patchSize+1);


[X, Y] = meshgrid(1:w, 1:h);
[theta, rho] = cart2pol(X - centerX, Y - centerY);
theta = theta + pi;

thetaBins = linspace(0, 2*pi, numAngles+1);
rhoBins = linspace(0, windowRadius, numRadii+1);

lssFeatures = zeros(1, numAngles * numRadii);
idx = 1;

for r = 1:numRadii
    for t = 1:numAngles
        binMask = theta >= thetaBins(t) & theta < thetaBins(t+1) & ...
            rho >= rhoBins(r) & rho < rhoBins(r+1);
        if any(binMask(:))
            lssFeatures(idx) = max(corrSurface(binMask));
        else
            lssFeatures(idx) = 0;
        end
        idx = idx + 1;
    end
end
end