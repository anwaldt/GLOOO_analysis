%% function [f0_step, tmpF0, f0_cor, f0_mod] = decompose(f0_svp, tresh1 ,cutOffLow, cutOffHigh)
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

function [cleanVEC, corVEC, modVEC] = decompose_trajectory(inVEC, param)

if param.info == true
    disp('    decompose_trajectory(): Starting...');
end

% the f0-sampling rate:
fs = 1/(param.lHop/param.fs); 


% vector for calculations
cleanVEC = soma_filter(inVEC);


%% POST PROCESSING


% low pass filtering
cutLow  = param.F0decomp.cutHighHZ/fs;
[b,a]   = butter(3,cutLow);
corVEC  = filter(b,a,cleanVEC);

% and high pass
cutHigh = param.F0decomp.cutLowHZ/fs;
[b,a]   = butter(3,cutHigh,'high');
modVEC  = filter(b,a,cleanVEC);





