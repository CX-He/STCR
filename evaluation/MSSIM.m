function [mssim ssim_out] = MSSIM(OriHSI, ResHSI)
% this function is to calculate the MPSNR of the restoration performance
%OriHSI is the true hyperspectral image with L*(nr*nc) dims
%ResHSI is the restorated image with the same dims

[M,N,L] = size(OriHSI);
[M1,N1,L1] = size(ResHSI);
if L~=L1 || N~=N1 || M~=M1
    disp(' The dims of the two matrix must be same!');
%     exit;
end
ssim_out = zeros(L,1);
for i= 1:L
    img1 = OriHSI(:,:,i);img2 = ResHSI(:,:,i);
    %ssim_out(i) = SSIM_2DGray(img1,img2);
    ssim_out(i) = ssim_gray(img2.*255,img1.*255);
    %ssim_out(i) = ssim(img2,img1);
end
mssim = mean(ssim_out);
end

function re = SSIM_2DGray(X,Y)
X=double(X);
Y=double(Y);

ux=mean(mean(X));
uy=mean(mean(Y));

sigma2x=mean(mean((X-ux).^2));
sigma2y=mean(mean((Y-uy).^2));
sigmaxy=mean(mean((X-ux).*(Y-uy)));

k1=0.01;
k2=0.03;
%L=max(max(X));
L = diff(getrangefromclass(X));
c1=(k1*L)^2;
c2=(k2*L)^2;
c3=c2/2;

l=(2*ux*uy+c1)/(ux*ux+uy*uy+c1);
c=(2*sqrt(sigma2x)*sqrt(sigma2y)+c2)/(sigma2x+sigma2y+c2);
s=(sigmaxy+c3)/(sqrt(sigma2x)*sqrt(sigma2y)+c3);
%c = (2*sigmaxy+c2)/(sigma2x+sigma2y+c2);

re=l*c*s;
%re=l*c;

end