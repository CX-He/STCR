function [mpsnr, psnr] = MPSNR(OriHSI, ResHSI)
% this function is to calculate the MPSNR of the restoration performance
%OriHSI is the true hyperspectral image with L*(nr*nc) dims
%ResHSI is the restorated image with the same dims

[M,N,L] = size(OriHSI);
[M1,N1,L1] = size(ResHSI);
if L~=L1 || N~=N1 ||M~=M1
    disp(' The dims of the two matrix must be same!');
%     exit;
end

for i= 1:L
    ori_img = OriHSI(:,:,i);
    diff_img = OriHSI(:,:,i)-ResHSI(:,:,i);
    psnr(i) = 10*log10( M*N * max(ori_img(:))^2 /sum(diff_img(:).^2));
end
mpsnr = sum(psnr) / L;