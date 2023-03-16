function X= Thres_1(B,lambda)
X=sign(B).*max(0,abs(B)-(lambda));
end