function [MCC, CC] = MCC(ref,tar)
%--------------------------------------------------------------------------
% Cross Correlation
%
% USAGE
%   out = CC(ref,tar)
%
% INPUT
%   ref : reference HS data (rows,cols,bands)
%   tar : target HS data (rows,cols,bands)
%
% OUTPUT
%   out : cross correlations (bands)
%
%--------------------------------------------------------------------------
[rows,cols,bands] = size(tar);

CC = zeros(1,bands);
for i = 1:bands
    tar_tmp = tar(:,:,i);
    ref_tmp = ref(:,:,i);
    cc = corrcoef(tar_tmp(:),ref_tmp(:));
    CC(1,i) = cc(1,2);
end
MCC = mean(CC(:));