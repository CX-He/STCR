function  [Y, Mat]  =  Cub2Patch( E_Img, Average, par )
TotalPatNum = (size(E_Img,1)-par.patsize+1)*(size(E_Img,2)-par.patsize+1);                  %Total Patch Number in the image
Y           =   zeros(par.patsize*par.patsize*size(E_Img,3), TotalPatNum, 'single');        %Current Patches
% N_Y         =   zeros(par.patsize*par.patsize*size(E_Img,3), TotalPatNum, 'single');        %Patches in the original noisy image
Mat         =   zeros(par.patsize*par.patsize, TotalPatNum, 'single');                      %Patches in the original noisy image
k           =   0;
for o = 1:size(E_Img,3)
    for i  = 1:par.patsize
        for j  = 1:par.patsize
            k     =  k+1;
            E_patch     =  E_Img(i:end-par.patsize+i,j:end-par.patsize+j,o);
%             N_patch     =  N_Img(i:end-par.patsize+i,j:end-par.patsize+j,o);
            Y(k,:)      =  E_patch(:)';
%             N_Y(k,:)    =  N_patch(:)';            
        end
    end
end

k           =   0;
for i  = 1:par.patsize
    for j  = 1:par.patsize
        k     =  k+1;
        Mat_patch   =  Average(i:end-par.patsize+i,j:end-par.patsize+j);
        Mat(k,:)    =  Mat_patch(:)';
    end
end