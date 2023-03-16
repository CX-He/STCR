function [A, At, P]   =  Compressive_sensing(im, rate)

    [A, At, P]    =  Random_Sensing(im, rate);

return;

function [A, At, P]   =  Random_Sensing(im, rate)
% rand('seed',0);
rng(1);
[h w ch]     =    size(im);

    N            =    h*w;
    K            =    round( N*rate );
    P            =    randperm(N)';
    q            =    randperm(N/2-1)+1;
    OMEGA        =    q(1:ceil(K))';
    A            =    @(z) A_f(z, OMEGA, P);
    At           =    @(z) At_f(z, N, OMEGA, P);
    P            =    OMEGA;

return;