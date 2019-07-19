%% function [f0_step, tmpF0, f0_cor, f0_mod] = decompose_trajectory()
%
% it discards  jumps greater than a certain treshold
% this leads to an extraction of the modulation trajectory
%
%   - cutHighHZ is the lowest estimated modulation frequency
%   - cutLowHZ is the highest estimated modulation frequency
%
% new version of separateF0trajectory()
%
% Author : Henrik von Coler
% Created: 2014-04-12
%%

function [cleanVEC, corVEC, modVEC, fluct] = decompose_trajectory(inVEC, param)

 

% the f0-sampling rate:
fs = 1/(param.lHop/param.fs);


% vector for calculations
cleanVEC = soma_filter(inVEC);


% get standard distribution features
tmpMed  = median(inVEC);
tmpMean = mean(inVEC);
tmpStd  = std(inVEC);


%%

% high pass filter
b = fir1(128,param.MARKOV.hpf_cutoff/(param.fs/param.lHop) ,'high');
fluct = filtfilt(b,1,inVEC);
fluct = fluct+tmpMed;

% low pass filtering
cutLow  = param.F0decomp.cutHighHZ/fs;
[b,a]   = butter(3,cutLow);
corVEC  = filter(b,a,cleanVEC);

% and high pass
cutHigh = param.F0decomp.cutLowHZ/fs;
[b,a]   = butter(3,cutHigh,'high');
modVEC  = filter(b,a,cleanVEC);


xxx = 1;





