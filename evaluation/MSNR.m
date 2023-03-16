function msnr = MSNR(OriHSI, ResHSI)
% this function is to calculate the MPSNR of the restoration performance
%OriHSI is the true hyperspectral image with L*(nr*nc) dims
%ResHSI is the restorated image with the same dims

[M,N,L] = size(OriHSI);
[M1,N1,L1] = size(ResHSI);
if L~=L1 || N~=N1 ||M~=M1
    disp(' The dims of the two matrix must be same!');
    exit;
end

msnr = 0;
for i= 1:L
    Ori_img = OriHSI(:,:,i).^2;
    Diff_img = (OriHSI(:,:,i)-ResHSI(:,:,i)).^2;
    snr = 10*log10(sum(Ori_img(:))/sum(Diff_img(:)));
    msnr = msnr  + snr;
end
msnr = msnr / L;