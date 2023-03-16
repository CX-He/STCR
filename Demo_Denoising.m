%% STCR for HSI Denoising
clc;
clear;
close all;
if isempty(gcp('nocreate')), parpool(); end
addpath(genpath('dataset'));
addpath(genpath('evaluation'));
addpath(genpath('STCR_func'));
addpath(genpath('toolbox'));

%% Noisy case 3
load('ORI_WDC_300x300x191.mat');
IMG=HSI_Normalization(double(IMG));
[M,N,L] = size(IMG);
NOISY_IMG = randn(size(IMG));
added_nSig=10/255+20/255*rand(L,1);
for i = 1 : L
    NOISY_IMG(:,:,i) = IMG(:,:,i) + added_nSig(i)*randn(M,N);
end
added_impulse_bands = 91:130;
added_impulse_density = 0.1;
for i = added_impulse_bands(1):added_impulse_bands(end)
    NOISY_IMG(:,:,i) = imnoise(NOISY_IMG(:,:,i), 'salt & pepper', added_impulse_density);
end
figure; imshow(NOISY_IMG(:,:,112),'border','tight','initialmagnification','fit'); set (gcf,'Position',[400,400,400,400]);
disp(['Noisy: MPSNR = ' num2str(MPSNR(IMG,NOISY_IMG)) '; SSIM = ' num2str(MSSIM(IMG,NOISY_IMG))]);

%% Parameter setting
p_CubeLen   = 8;     % Better in [6, 12]
p_CubeNum   = 5;     % Better in [5, 10]
p_SubDim    = 9;     % Better in [5, 10]
p_CRank     = [ceil(p_CubeNum/2),ceil(p_SubDim/2)];     % Cascaded Rank
p_RegLR     = 100;   % Better in [1, 100]
p_RegS      = 0.03;  % Better in [0.01, 0.1]
p_Iter      = 50;    % Iteration times

%% Main function
tic
[De_STCR] = STCR_Denoising_fast(NOISY_IMG, IMG, ...
    p_CubeLen, p_CubeNum, p_SubDim, p_CRank, ...
    p_RegLR, p_RegS, p_Iter);
time=toc;
name = ['WDC3'  '_Subdim' num2str(p_SubDim) '_Rank[' num2str(p_CRank) ']'...
    '_CubeLen' num2str(p_CubeLen) '_CubeNum' num2str(p_CubeNum)...
    '_RegLR' num2str(p_RegLR) '_RegS' num2str(p_RegS) '_Iter' num2str(p_Iter) ];

%% Eval and save
[q_psnr_mean,q_psnr] = MPSNR(IMG,De_STCR);
[q_ssim_mean,q_ssim] = MSSIM(IMG,De_STCR);
% [q_fsim_mean,q_fsim] = MFSIM(IMG,Ys_STCR);
% [q_msa_mean, q_msa] = MMSA(IMG, Ys_STCR);
% [q_uiqi_mean, q_uiqi] = MUIQI(IMG,Ys_STCR, 8);
% [q_cc_mean, q_cc] = MCC(IMG,Ys_STCR);
% q_ergas = ErrRelGlobAdimSyn(IMG,Ys_STCR);

save([name '.mat'],'De_STCR',...
    'p_SubDim','p_CubeLen','p_CubeNum','p_CRank','p_RegLR','p_RegS','p_Iter',...
    'q_psnr_mean','q_psnr','q_ssim_mean','q_ssim','time');
figure; imshow(De_STCR(:,:,112),'border','tight','initialmagnification','fit'); set (gcf,'Position',[800,400,400,400]);
disp(['Denoised: MPSNR = ' num2str(q_psnr_mean) '; SSIM = ' num2str(q_ssim_mean) '; Time = ' num2str(time) newline]);