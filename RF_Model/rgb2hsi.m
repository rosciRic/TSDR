function hsi = rgb2hsi(rgb)
rgb = im2double(rgb);
R = rgb(:,:,1);
G = rgb(:,:,2);
B = rgb(:,:,3);

num = 0.5 * ((R - G) + (R - B));
den = sqrt((R - G).^2 + (R - B).*(G - B));
theta = acos(num./(den + eps));

H = theta;
H(B > G) = 2*pi - H(B > G);
H = H/(2*pi);

min_RGB = min(min(R, G), B);
sum_RGB = R + G + B;
S = 1 - 3.* min_RGB./(sum_RGB + eps);

I = sum_RGB/3;

H(S==0) = 0;
hsi = cat(3, H, S, I);
end

