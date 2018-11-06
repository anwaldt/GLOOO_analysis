
%% residual_synth_MAIN.m
%
% Test the residual synthesis 
% using the bark-band-filtered noise.
%
% Henrik von Coler
% 2018-11-05
%
%%

clearvars

addpath('../../common');


addpath('../MATLAB/SWIPE/');
addpath('../MATLAB/yaml/');
addpath('../MATLAB/Functions/');
addpath('../MATLAB/Classes/');

p = genpath('../MATLAB/orchidas-pitch-tracking');
addpath(p)

p = genpath('../GLOOO_Solo_Analysis/Matlab');
addpath(p);



%%

nr = '56';

load(['/mnt/wintermute/mnt/DATA/USERS/HvC/TU-Note_Violin/Analysis/2018-11-05/SingleSounds/BuK/Sinusoids/SampLib_BuK_' nr '.mat'])

fs = 48000;

C = make_bark_filterbank(fs,3);

nBands  = size(SMS.BET,2);
nFrames = size(SMS.BET,1);


lHop = SMS.param.lHop;
lWin = SMS.param.lWinNoise;


idx = 1;

y = zeros(1000000,1);

for frameCNT = 1:nFrames
    
    for bandCNT = 1:nBands
        
        n = randn(lWin,1);
        
        tmp = filter(C{bandCNT}.b,C{bandCNT}.a,n);
        
        tmp = tmp.*hann(lWin).*SMS.BET(frameCNT,bandCNT);
        
        y(idx:idx+lWin-1) =  y(idx:idx+lWin-1) + tmp;
    end
    
    idx=idx+lHop;

end

audiowrite([nr '.wav'],y,fs)