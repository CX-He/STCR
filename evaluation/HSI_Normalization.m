function img_nor=HSI_Normalization(img_unnor)
img_unnor = double(img_unnor);
[M,N,L]=size(img_unnor);
img_nor=zeros(M,N,L);
for index=1:L
    band_img=img_unnor(:,:,index);
    max_band_img=max(band_img(:));
    min_band_img=min(band_img(:));
    band_img_nor=(band_img-min_band_img)/(max_band_img-min_band_img);
    img_nor(:,:,index)=band_img_nor;
end
end

