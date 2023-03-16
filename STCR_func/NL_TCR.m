function [E_Img, Spa_Img, Spa_Wei] = NL_TCR(N_Img, p_PatchLength, p_PatchNum, p_CRank)
Par.patsize = p_PatchLength;
Par.patnum = p_PatchNum;
Par.CRank = p_CRank;
Par.step = 2;
Par.SearchWin =30;
%%
E_Img            = N_Img;
% Average          = mean(N_Img,3);
[Height, Width, Band]  = size(E_Img);
Average = reshape(E_Img, Height*Width, Band)';
[U,~] = svd(Average,'econ');
Average = U(:,1)'*Average;
Average = reshape(Average', Height, Width);
%%
[Neighbor_arr, Num_arr, Self_arr] =	NeighborIndex(Average, Par);
[CurPat, Mat]	=	Cub2Patch(E_Img, Average, Par );
% Par.patnum = Par.patnum - 10;
NL_mat  =  Block_matching(Mat, Par, Neighbor_arr, Num_arr, Self_arr);
%%
EPat = zeros(size(CurPat));
W    = zeros(size(CurPat));
Temp = cell(length(Self_arr),1);
E_Temp = cell(length(Self_arr),1);
%%
for i = 1:length(Self_arr)
    Temp{i} =  CurPat(:, NL_mat(1:Par.patnum,i));
end
%%
parfor i = 1:length(Self_arr)
% for i = 1:length(Self_arr)
    E_Temp{i}    =  NL_TCR_PatEstimation(Temp{i},Par);
end
%%
for  i      =  1 : length(Self_arr)
    EPat(:,NL_mat(1:Par.patnum,i))  = EPat(:,NL_mat(1:Par.patnum,i)) + E_Temp{i};
    W(:,NL_mat(1:Par.patnum,i))     = W(:,NL_mat(1:Par.patnum,i)) + ones(size(CurPat,1),size(NL_mat(1:Par.patnum,i),1));
end
%%
% Estimate the spatial patches
[Spa_Img, Spa_Wei]   =  Patch2Cub( EPat, W, Par.patsize, Height, Width, Band );       % Patch to Cubic
E_Img = Spa_Img./Spa_Wei;
end

function [E_Temp] = NL_TCR_PatEstimation(Temp,Par)
sizeD = size(Temp);
E_Temp = reshape(Temp,Par.patsize*Par.patsize,sizeD(1)/((Par.patsize)*(Par.patsize)),sizeD(2));
E_Temp = permute(E_Temp,[1,3,2]);
E_Temp = TCR_dec(E_Temp,Par);
E_Temp = ipermute(E_Temp,[1,3,2]);
E_Temp = reshape(E_Temp,sizeD);
end