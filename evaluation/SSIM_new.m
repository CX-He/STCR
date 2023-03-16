function re = SSIM_new(X,Y)
X=double(X);
Y=double(Y);

ux=mean(mean(X));
uy=mean(mean(Y));

sigma2x=mean(mean((X-ux).^2));
sigma2y=mean(mean((Y-uy).^2));
sigmaxy=mean(mean((X-ux).*(Y-uy)));

k1=0.01;
k2=0.03;
L=max(max(X));
c1=(k1*L)^2;
c2=(k2*L)^2;
%c3=c2/2;

l=(2*ux*uy+c1)/(ux*ux+uy*uy+c1);
% c=(2*sqrt(sigma2x)*sqrt(sigma2y)+c2)/(sigma2x+sigma2y+c2);
% s=(sigmaxy+c3)/(sqrt(sigma2x)*sqrt(sigma2y)+c3);
c = (2*sigmaxy+c2)/(sigma2x+sigma2y+c2);

%re=l*c*s;
re=l*c;