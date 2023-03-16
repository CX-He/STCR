function [r] = dirichlet_rnd(a,dim)

%DIRICHLET_RND Random matrices from dirichlet distribution.
%   R = DIRICHLET_RND(A,DIM) returns a matrix of random numbers chosen   
%   from the dirichlet distribution with parameters vector A.
%   Size of R is (N x N) where N is the size of A or (N x DIM) if DIM is given.
%
%  Copyright: José Nascimento (zen@isel.pt)
%             & 
%             José Bioucas-Dias (bioucas@lx.it.pt)
%
%  For any comments contact the authors

if nargin < 1, error('Requires at least one input arguments.'); end
if nargin > 2, error('Requires at most two input arguments.'); end

[rows columns] = size(a); 
if nargin == 1, dim = rows * columns; end
if nargin == 2, 
   if numel(dim) ~= 1, error('The second parameter must be a scalar.'); end
end
if rows~=1 & columns~=1, error('Requires a vector as an argument.'); end
if any( a < 0 | ~isreal(a)), error('Parameters of Dirichlet function must be real positive values.');end

N = rows * columns;

% fastest method that generalize method used to sample from
% the BETA distribuition: Draw x1,...,xk from independent gamma 
% distribuitions with common scale and shape parameters a1,...,ak, 
% and for each j, let rj=xj/(x1+...+xk).
%
% Correction the inverse scale is set to one ze_nash 18/10/2004
%
x = zeros(dim,N);
for i = 1 : N
    x(:,i) = gamrnd(a(i),1,dim,1); % generates dim random variables 
end                                   % with gamma distribution
r = x./repmat(sum(x,2),[1 N]);
return
% end of function [r] = dirichlet_rnd(a,dim)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A less efficient algorithm relies on the univariate marginal and 
% conditional distributions being beta and proceeds as follows.
% Simulate r1 from beta(a1,a2+...+aN) distribution. Then simulate
% r2,...,r(N-1) in order, as follows. for j=2,...,N-1, simulate Qj
% from a beta(aj,a(j+1)+...+aN) distribution, and let rj=(1-(ri+...+r(j-1)))
% finally, set rN=1-(r1+...+r(N-1)).
%
%at = fliplr(cumsum(fliplr(a(2:N))));
%q = zeros(dim,N);
%r = zeros(dim,N);
%r(:,1) = betarnd(a(1),at(1),dim,1);
%rt = r(:,1);
%for j=2:N-1
%   qj = betarnd(a(j),at(j),dim,1);
%   r(:,j) = (1-rt).*qj;
%   rt = rt + r(:,j);
%end
%r(:,N)=1-rt;
 
% For more details see "Bayesian Data Analysis" Appendix A



