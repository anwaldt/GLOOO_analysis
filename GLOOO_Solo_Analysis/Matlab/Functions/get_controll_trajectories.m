%% function [features] = get_controll_trajectories(paths,param)
%
% Extracts the 'control features' (F0, rms, ... )
%
% now uses only swipe, yin feature has been commented
%
% Henrik von Coler
%
% Created: 2014-02-17
% Edited : 2016-08-09
%
%%

function [features] = get_controll_trajectories(x,param, fileName)


%% Prepare Basics

fs                  = param.fs;
L                   = length(x);
nWin                = floor((L)/param.lHop);
features.rmsVec     = zeros(nWin,1);


%% Swipe

% translate hop.size to seconds
hopSec                  = param.lHop/param.fs;
[swipeVec,t,ps]         = swipep(x,fs,[30 3000],hopSec);
features.f0swipe        = swipeVec(1:nWin);
features.pitchStrenght  = ps;


%% YIN

% prepare parameter struct
% P.sr    = fs;
% P.hop   = param.lHop;
% P.wsize = param.lWinYIN;
% P.minf0 = param.fMin;
% P.maxf0 = param.fMax;
% 
% % call yin
% YIN     = yin('',P);
% f0yin   = YIN.f0;
% 
% % delete nans
% f0yin(isnan(f0yin)) = 0;
% 
% % recalc to Hz
% f0yin               = 440*2.^(f0yin);
% features.f0yin      = f0yin(1:nWin)';


%% RMS

pad = zeros(param.lWinRMS,1);
x   = [pad; x; pad];

for frameCount = 1:nWin
    
    frame = x((frameCount-1)*param.lHop - param.lWinRMS/2 + param.lWinRMS: ...
        (frameCount-1)*param.lHop + param.lWinRMS/2 -1  +param.lWinRMS);
    
    features.rmsVec(frameCount) = rms(frame);
    
end


end

