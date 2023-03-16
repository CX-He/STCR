function [U,S,V] = tsvd(X,opt)

% [U,S,V] = tsvd(X,opt) computes a tensor SVD, i.e., X=U*S*V^*, where S
% is a f-diagonal tensor, U and V are orthogonal tensors.
%
%
% Input:
%       X     - n1*n2*n3 tensor
%       opt   - options for different outputs of U, S and V:
%           'full': (default) produces full tensor SVD, i.e., X = U*S*V^*, where
%                   U - n1*n1*n3
%                   S - n1*n2*n3
%                   V - n2*n2*n3
%           'econ': produces the "economy size" decomposition. 
%                   Let m = min(n1,n2). Then, X = U*S*V^*, where
%                   U - n1*m*n3
%                   S - m*m*n3
%                   V - n2*m*n3
%           'skinny': produces the skinny tensor SVD.
%                   Let r be the tensor tubal rank of X. Then, X = U*S*V^*, where
%                   U - n1*r*n3
%                   S - r*r*n3
%                   V - n2*r*n3
%
% Output: U, S, V
%
% version 1.0 - 18/06/2016
% version 2.0 - 09/10/2017 a more efficient version
% version 2.1 - 13/06/2018 add a new input parameter option
% version 2.2 - 28/04/2021
%
% Written by Canyi Lu (canyilu@gmail.com)
% 
%
% References:
% Canyi Lu, Tensor-Tensor Product Toolbox. Carnegie Mellon University. 
% June, 2018. https://github.com/canyilu/tproduct.
%
% Canyi Lu, Jiashi Feng, Yudong Chen, Wei Liu, Zhouchen Lin and Shuicheng
% Yan, Tensor Robust Principal Component Analysis with A New Tensor Nuclear
% Norm, TPAMI, 2019
%

if ~exist('opt', 'var')
    opt = 'full';
end

[n1,n2,n3] = size(X);
X = fft(X,[],3);
if strcmp(opt,'skinny') == 1 || strcmp(opt,'econ') == 1 
    min12 = min(n1,n2);
    U = zeros(n1,min12,n3);
    S = zeros(min12,min12,n3);
    V = zeros(n2,min12,n3);
    
    halfn3 = ceil((n3+1)/2);
    for i = 1 : halfn3
        [U(:,:,i),S(:,:,i),V(:,:,i)] = svd(X(:,:,i),'econ');
    end
    for i = halfn3+1 : n3
        U(:,:,i) = conj(U(:,:,n3+2-i));
        V(:,:,i) = conj(V(:,:,n3+2-i));
        S(:,:,i) = S(:,:,n3+2-i);
    end
    
    if strcmp(opt,'skinny') == 1
        s1 = diag(sum(S,3))/n3^2;
        tol = max(n1,n2)*eps(max(s1));
        trank = sum(s1 > tol); % tensor tubal rank
        U = U(:,1:trank,:);
        V = V(:,1:trank,:);
        S = S(1:trank,1:trank,:);        
    end
    
elseif strcmp(opt,'full') == 1
    U = zeros(n1,n1,n3);
    S = zeros(n1,n2,n3);
    V = zeros(n2,n2,n3);
    
    halfn3 = ceil((n3+1)/2);
    for i = 1 : halfn3
        [U(:,:,i),S(:,:,i),V(:,:,i)] = svd(X(:,:,i));
    end
    for i = halfn3+1 : n3
        U(:,:,i) = conj(U(:,:,n3+2-i));
        V(:,:,i) = conj(V(:,:,n3+2-i));
        S(:,:,i) = S(:,:,n3+2-i);
    end
end

U = ifft(U,[],3);
S = ifft(S,[],3);
V = ifft(V,[],3);
