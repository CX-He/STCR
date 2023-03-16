function [ res ] = Thres_21(x, tau)
        v = sqrt(sum(x.^2,3));
        v(v==0) = 1;
        % Weighted group sparsity
        res = repmat(max(1 - tau.*(1./(abs(v)+eps)) ./ v, 0), 1, 1, size(x,3)) .* x;  
        % Group sparsity (without weighted)
%      res = repmat( max(1 - tau ./ v, 0), 1, 1, size(x,3) ) .* x;
end