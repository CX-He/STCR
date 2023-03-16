%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Demo file: Signal subspace estimation  
%            of real data set with
%            HySime method
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, clc, close all
verbose='on';

%data_set = 'cuprite';
data_set = 'indian_pine';


if strcmp(verbose,'on'),fprintf(1,'loading %s data set\n',data_set);end

switch data_set
    case 'cuprite'
         load cup_ref_350x350;      % Get the Cuprite reflectance data  
         x = x(BANDS,:)/gain;
         clear C C_INI C_END L L_INI L_END gain image wl 
         noise_type = 'additive';
    case 'indian_pine'
         load indian_site
         x=reshape(R,[Columns*Lines B])';
         clear Columns Lines R file_name image_name
         wavlen=1:B;
         x = x(BANDS,:);
         [B N]=size(x);
         noise_type='poisson';
end

[w Rn] = estNoise(x,noise_type,verbose);

sel_pixel = round((N-1)*rand(1));
figure(1);
  set(gca,'FontSize',12,'FontName','times new roman');
  subplot(221);
     xp = nan*ones(B,1);
     xp(BANDS) = x(:,sel_pixel);
     plot(wavlen,xp,'r-','Linewidth',1);
     axis([min(wavlen) max(wavlen) 0 1.2*max(xp)])
     xlabel('\lambda(\mum)')  
     title('pixel signature')
  subplot(222);
     wp = nan*ones(B,1);
     wp(BANDS) = w(:,sel_pixel);
     plot(wavlen,wp,'b-','Linewidth',1);
     axis([min(wavlen) max(wavlen) min(wp) max(wp)])
     xlabel('\lambda(\mum)')  
     title('noise estimates')
  subplot(223);
     d = nan*ones(B,1);
     d(BANDS) = diag(Rn);
     plot(wavlen,d,'b-','Linewidth',1);
     axis([min(wavlen) max(wavlen) 0 1.2*max(d)])
     xlabel('\lambda(\mum)')  
     title('diagonal of the noise covariance matrix');

[kf Ek]=hysime(x,w,Rn,verbose);    % estimate the p
if ~strcmp(verbose,'on'),fprintf(1,'The signal subspace dimension is: k = %d\n',kf);end

return


 