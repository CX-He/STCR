function  par  =  Set_parameters(rate)
par.win        =    6;    % Patch size
par.nblk       =    45;    
par.step       =    min(6, par.win-1);
par.beta       =    0.01;
%-------------------------------------------------------
% The random sampling pattern used in L1-magic software
%-------------------------------------------------------

%     par.K0     =   3;
%     par.K      =   15;
%     par.c0     =   0.49;
    par.K0     =   3;
    par.K      =   15;
    par.c0     =   0.49;
    
    if rate<=0.05
        par.t0         =   3.8;            %  Threshold for DCT reconstruction     
        par.nSig       =   4.66;           %  4.45          
        par.c0         =   0.6;            %  0.6     Threshold for warm start step
        par.c1         =   2.2;            %  1.96    Threshold for weighted SVT
            
    elseif rate<=0.1                      
        par.t0         =   2.4;     
        par.nSig       =   3.25;         
        par.c1         =   1.55;   
        
    elseif rate<=0.15                 
        par.t0         =   1.8;     
        par.nSig       =   2.65;         
        par.c1         =   1.35;  
        
    elseif rate<=0.2           
        par.t0         =   1.4;     
        par.nSig       =   2.35;         
        par.c1         =   1.32;  
        
    elseif rate<=0.25
        par.t0         =   1.0;     
        par.nSig       =   2.1;  
        par.c1         =   1.15;  
        
    elseif rate<=0.3
        par.t0         =   0.8; 
        par.nSig       =   1.8;      
        par.c1         =   0.9;
        
    else
        par.t0         =   0.8; 
        par.nSig       =   1.4;  
        par.c1         =   0.75; 
    end    

return;