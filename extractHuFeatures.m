function features = extractHuFeatures(objectStats)
    hu = invmoments(objectStats.Image);
    circularity = objectStats.Circularity;
    features = [hu, circularity];
end