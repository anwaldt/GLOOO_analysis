%% function [ noise ] = residual_synth_tester(noiseFrames, param)
%
%
%
%%
function [ noise ] = residual_synth_tester(noiseFrames, lOut, param)


nFrames     = size(noiseFrames,1);
noise       = zeros(lOut,1);



meanNoise   = mean(noiseFrames,1);
noiseEnergy = mean(noiseFrames,2)/mean(mean(noiseFrames,2));
noiseDev    = var(noiseFrames,1);

idxs = 1:param.PART.lWin;

for frameCnt = 1:nFrames
    
    
    %
    %     resEnv      = cepstral_smoothing(residual,0.99);
    % resEnv      = resEnv(1:length(resEnv)/2);
    
    N           = size(noiseFrames,2)*2;
    
    %RES         = noiseFrames(frameCnt,:);
    RES = meanNoise.*noiseEnergy(frameCnt)*2;
    
    % RESph a = angle(RES);
    RESabs      = abs(RES);
    
    % smooth in the log domain
    REStmp      = smooth(log(RESabs),5);
    
    % and return to linear
    RESsmooth   = exp(REStmp);
    
    % IPMORTANT: use random phase !!!!!
    % (everything else will lead to choppy sound)
    randPhase   = (rand(size(RES))-0.5)*2*pi;
    
    % compose imaginary and real spectra separately,
    % so that the phase is not affected by the window function
    rP = RESsmooth .* cos(randPhase)';
    iP = RESsmooth .* 1i.*sin(randPhase)';
    
    compSpec    = rP+iP;
    
    resFrame    = fftshift( ifft([compSpec; zeros(N/2,1)] ,'symmetric'));
    
    resFrame    = resFrame.*triang(N);
    
    try
        noise(idxs) =    noise(idxs)+resFrame;
    catch
        'xxx';
    end
    
    idxs = idxs+param.lHop;
end

end

