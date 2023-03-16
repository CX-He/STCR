function [y,x,M,s,n,Cn,wavlen]=generate_hyperspectral_data(p,N,SNR,eta,noise_type,verbose)
%
% generate_hyperspectral_data: generate a simulated 
% hyperspectral data set
%
% Input:
%      p:  number of endmembers
%      N:  number of pixels
%      SNR: signal-to-noise ratio in dB
%      eta: parameter to control noise
%          white noise (eta = 0)
%          color noise (eta > 0)
%      noise_type: 
%          poisson noise (noise_type = 'poisson')
%          additive noise (noise_type = 'other')
%      verbose: 'on', 'off'
% Output:
%      y is a L x N matrix with the hyperspectral data set 
%        (L is the number of bands) 
%      x is the signal (endmembers linear mixture)
%      M endmembers signatures (Lxp)
%      s abundance fractions (Nxp)
%      n additive noise (Lxp)
%      Cn noise correlation matrix (LxL)
%      wavlen Wavelengths in microns
%
%  Copyright: José Nascimento (zen@isel.pt)
%             & 
%             José Bioucas-Dias (bioucas@lx.it.pt)
%
%  For any comments contact the authors

verbose = ~strcmp(lower(verbose),'off');

if verbose,fprintf(1,'generating sinthetic data set with %d pixels\n', N);end

% generate the abundances according to equation (3)
if verbose,fprintf(1,'abundance sources are generated according to a Dirichlet distribution\n');end
s = dirichlet_rnd([ones(1,p)/p],N); 


% signatures from USGS Library 
load('USGS_1995_Library')
wavlen=datalib(:,1); % Wavelengths in microns
[L n_materiais]=size(datalib);
sel_mat = 4+randperm(n_materiais-4);
sel_mat = sel_mat(1:p);
M = datalib(:,sel_mat); 
%
[wavlen indx]=sort(wavlen);
M = M(indx,:);
%
if verbose, 
   fprintf('%d endmembers from USGS Library:\n', p); 
   for i=1:p, fprintf(1,'\t');fprintf(1,'%c',names(sel_mat(i),:));end;
end
%linear mixture: equation (1)
x = M * s' ; 

% adding noise
if verbose,fprintf(1,'Signal-to-noise ratio set to: %d dB\n', SNR);end
if isinf(SNR), n=zeros(L,N);Cn=zeros(L);      % no noise case
else
   if verbose, fprintf(1,'Noise type: %s\n',noise_type);end
   varianc = sum(x(:).^2)/10^(SNR/10) /L/N ;
   if strcmp(noise_type,'additive')              % color & white noise case
      % note that eta is 1/eta in equation (4) 
      quad_term = exp(-((1:L)-L/2).^2*eta^2/2);
      varianc_v = varianc*L*quad_term/sum(quad_term);
      Cn = diag(varianc_v); 
      n = sqrtm(Cn)*randn([L N]);
   end
   if strcmp(noise_type,'poisson')
      factor = varianc/mean(x(:)); 
      n = sqrt(factor) * sqrt(x) .* randn([L N]);
      Cn = diag(factor * mean(x,2)); %n*n'/N;
   end
end

y = x + n; % hyperspectral observations: equation(1)

return
        