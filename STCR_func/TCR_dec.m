function X = TCR_dec(Y, Par)
Y = double(Y);
[M,N,L]=size(Y);

%%
Y_spatial=reshape(Y, M, N*L);
Y_spatial=LowRankRecovery3(Y_spatial, 1);
Y_spatial=reshape(Y_spatial, M, N, L);

%%
Y_Ten=permute(Y_spatial , [2,3,1]);
[U1,S1,V1]=tsvd(Y_Ten);
Y_Ten_Nonlocal=tprod(tran(U1),Y_Ten);
Y_Ten_Nonlocal(Par.CRank(1)+1:end,:,:) = [];

%%
Y_Ten_spectral=permute(Y_Ten_Nonlocal,[2,3,1]);
[U2,S2,V2]=tsvd(Y_Ten_spectral);
Y_Ten_spectral=tprod(tran(U2),Y_Ten_spectral);
Y_Ten_spectral(Par.CRank(2) + 1:end,:,:) = [];

%%
Y_Ten_Nonlocal=ipermute(tprod(U2(:,1:Par.CRank(2),:),Y_Ten_spectral), [2,3,1]);
Y_spatial=ipermute(tprod(U1(:,1:Par.CRank(1),:),Y_Ten_Nonlocal), [2,3,1]);
X=Y_spatial;
end