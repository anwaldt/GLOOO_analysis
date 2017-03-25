%% basic_analysis().m
%
% Get control trajectories, features and sinusoidal trajectories
%
% Henrik von Coler
%
% Created : 2016-09-28
%
%%

function [SMS] = partial_analysis(baseName, paths)



%% load control trajectories

load([paths.features baseName])

param = CTL.param;

partialName = [paths.sinusoids baseName '.mat'];

if exist(partialName,'file') == 0
    
    
    %% READ WAV
    
    audioPath = [paths.wavPrepared baseName '.wav'];
    
    try
        [x,fs]      = audioread(audioPath);
    catch
        [x,fs]      = wavread(audioPath);
    end
    
    
    %% CALL the Partial Analysis
    
    
    
    % only calculate, if not existent
    %
    psVec = (smooth(CTL.pitchStrenght,100));
    
    [f0vec, SMS, noiseFrames, residual, tonal]  = get_partial_trajectories(x, param, CTL.f0swipe, psVec);
    
    
    SMS.param = param;
    
    save(partialName, 'SMS');
    
    wavwrite(tonal, param.fs, [paths.tonal baseName '.wav']);
    wavwrite(residual, param.fs, [paths.residual baseName '.wav']);
    
else
    
    load(partialName)
    
end

end


