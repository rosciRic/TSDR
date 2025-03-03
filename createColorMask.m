function mask = createColorMask(H, S, I)
redMask = ((H >= 0 & H <= 10) | (H >= 300 & H <= 360)) & ...
    (S >= 25 & S <= 250) & ...
    (I >= 30 & I <= 200);

blueMask = (H >= 190 & H <= 260) & ...
    (S >= 70 & S <= 250) & ...
    (I >= 56 & I <= 128);

mask = redMask | blueMask;
end