%% basic_analysis().m
%
% Get control trajectories, features and sinusoidal trajectories
%
% Henrik von Coler
%
% Created : 2016-09-28
%
%%

function [CTL, param] = basic_analysis(baseName, paths, param)



%% READ WAV

audioPath = [paths.wavPrepared baseName '.wav'];

try
    [x,fs]      = audioread(audioPath);
catch
    [x,fs]      = wavread(audioPath);
end

% add sample rate to parameters
param.fs    = fs;



%% Controll parameter ANALYSIS

CTL = get_controll_trajectories(x, param, audioPath);

if param.plotit == true
    
    figure
    subplot(2,1,1)
    plot(CTL.f0swipe,'r')
    
    hold off
    legend({'FO (swipe)'});
    title('F0 estimation')
    subplot(2,1,2)
    plot(CTL.pitchStrenght)
    title('Pitch Strength')
    legend({'pitch-strength'});
    
    % amplitude plot
    figure
    plot(x);
    hold on;
    plot((1:length(CTL.rmsVec))*param.lHop, CTL.rmsVec*2,'r')
    legend({'x(t)','RMS x 2'});
    title('RMS ')
    
end


CTL.param = param;

save([paths.features regexprep(baseName,'.wav','.mat')],'CTL')


