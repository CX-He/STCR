function [Ys] = STCR_Denoising_fast(Y_3D, XT, p_PatchLength, p_PatchNum, p_SubDim, p_CRank, p_RegLR, p_RegS, p_Iter)
[M,N,L] = size(Y_3D);

%% Init
Y = reshape(Y_3D, M*N, L)';
[~, Rw]    = estNoise(Y, 'additive', 'off');
Y = sqrt(inv(Rw))*Y;

[B,~,~]=svd(Y,'econ');
B = B(:,1:p_SubDim); % size of band*sub_dim

mu = 1;
D  = diag(-ones(L,1))+diag(ones(L-1,1),1);
D(L,1) = 1;
H1 = (2/mu).*(D*D');
F_H1   = abs(fft(H1));

%% Low-rank dec.
C = reshape((B'*Y)', M, N, p_SubDim);
[C, Spa_Img, Spa_Wei] = NL_TCR(C, p_PatchLength, p_PatchNum, p_CRank);
C = reshape(C, M*N, p_SubDim)';
Spa_Img = reshape(Spa_Img, M*N, p_SubDim)';
Spa_Wei = reshape(Spa_Wei, M*N, p_SubDim)';

%% Verbose
% q_psnr_i = zeros(p_Iter+1,1);
% q_sam_i = zeros(p_Iter+1,1);
% Ys=sqrt(Rw)*(B*C);
% Ys=reshape(Ys',M,N,L);
% [mpsnr,~] = MPSNR(XT,Ys);
% [msam, ~] = MMSA(XT, Ys);
% q_psnr_i(1)=mpsnr;
% q_sam_i(1)=msam;
for iter = 1:p_Iter
    %% update S
    S = Thres_1( Y-B*C, p_RegS );
%     W = 1./(abs((Y-B*C)+eps)); 
%     S = Thres_21((Y-B*C),W.*p_RegS);
    %% update Z
    C = (p_RegLR*Spa_Img + B'*(Y-S)) ./ (p_RegLR*Spa_Wei + mu);
    %% update E
    H2 = C*C';
    [U,Sig,~] = svd(H2);
    H3 = (Y-S)*C'*(1/mu);
    B = real(ifft((1./(F_H1*eye(L, p_SubDim)+(Sig*ones(p_SubDim, L))')).*(fft(H3)*U)))*U';
    
    %% Verbose
%     Ys_last = Ys;
%     Ys = sqrt(Rw)*(B*C);
%     Ys = reshape(Ys',M,N,L);
%     [mpsnr,~] = MPSNR(XT,Ys);
%     [msam, ~] = MMSA(XT, Ys);
%     q_psnr_i(iter+1) = mpsnr;
%     q_sam_i(iter+1)=msam;
%     if mod(iter, 10)==1
%         disp(['Iter = ' num2str(iter) '; tol = ' num2str(norm(Ys(:)-Ys_last(:),'fro')/norm(Ys_last(:),'fro'))...
%             '; psnr = ' num2str(q_psnr_i(iter+1)) '; sam = ' num2str(q_sam_i(iter+1)) ';']);
%     end
end
Ys = sqrt(Rw)*(B*C);
Ys = reshape(Ys',M,N,L);
end
