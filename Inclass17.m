%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 
clear all
img1 = imread('img1.tif');
img2 = imread('img2.tif');

figure(1)
imshow(imadjust(img1));
figure(2)
imshow(imadjust(img2));

diff = zeros(800);
for c = 1:500
    for r = 1:500
        pix1 = img1((800-r):800,(800-c):800);
        pix2 = img2(1:(1+r),1:(1+c));
        corr(r,c) = mean2((pix1-mean2(pix1)).*(pix2-mean2(pix2)));
    end
end

[max_c,r] = max(corr);
[max_r,c] = max(max_c);
pos = [r(c),c];


img2_align = zeros(size(img2)+[800,800]-pos);
img2_align((801-pos(1)):(1600-pos(1)),(801-pos(2)):(1600-pos(2))) = img2;
figure(3)
imshowpair(img1,img2_align)


%fourier
img1f = fft2(img1);
img2f = fft2(img2);
[nr,nc] = size(img2f);
CC = ifft2(img1f.*conj(img2f));
CCabs = abs(CC);
[row_shift,col_shift] = find(CCabs == max(CCabs(:)));
Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
row_shift = Nr(row_shift);
col_shift = Nc(col_shift);
img_shift = zeros(size(img1)+size(img2)-[row_shift,col_shift]);
img_shift((end-799):end,(end-799):end)=img2;
figure(4)
imshowpair(img1,img_shift);
