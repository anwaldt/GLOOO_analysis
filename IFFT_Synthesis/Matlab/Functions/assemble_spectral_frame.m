function [tmpFrame,s] = assemble_spectal_frame(s,f0,Aframe,win2, lWin,fs,kernels,kernels_LF,fracVec,fracVec_LF)

    FRAME = zeros(lWin,1);
    nPart = length(s);
    
% loop over all partials
    for partCnt = 1:nPart
        
        % partial frequency (is always exactly N*f0)
        s(partCnt).f0  = f0 * partCnt;
        
        %
        s(partCnt).a   = Aframe(partCnt);
    
        
        % add this partial to the spectrum
        [tmpFrame, s(partCnt)] = place_mainlobe( s(partCnt),lWin,fs,kernels,kernels_LF,fracVec, fracVec_LF);
        FRAME    = FRAME+tmpFrame./4;
        
    end
    
    % transform
    tmpFrame  =  (ifft(FRAME,'symmetric'));
    
    % get rid of the BH-window in time-domain and apply triangular window
    tmpFrame  = tmpFrame.*win2;