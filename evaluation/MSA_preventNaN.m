function msa = MSA(OriHSI, ResHSI)
% this function is to calculate the MPSNR of the restoration performance
%OriHSI is the true hyperspectral image with L*(nr*nc) dims
%ResHSI is the restorated image with the same dims

[M,N,L] = size(OriHSI);
[M1,N1,L1] = size(ResHSI);
if L~=L1 || N~=N1||M~=M1
    disp(' The dims of the two matrix must be same!');
    exit;
end
Msa_all = acos(sum(OriHSI.* ResHSI,3)./(sqrt(sum(OriHSI.* OriHSI,3)).* sqrt(sum(ResHSI.* ResHSI,3))));

for i = 1:M
    for j =1:N
        if isnan(Msa_all(i,j))
            Msa_all(i,j)=0;
        end
    end
end

msa = mean(Msa_all(:));

