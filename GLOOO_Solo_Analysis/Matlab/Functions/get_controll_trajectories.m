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

function [features] = get_controll_trajectories(x,param, fileName, INF)


%% Prepare Basics

fs                  = param.fs;
L                   = length(x);
nWin                = floor((L)/param.lHop);
features.rmsVec     = zeros(nWin,1);

%% Filter input for better results
if param.info == true
    disp('    get_controll_trajectories(): prefilter input with bandpass');
end

filter_type = 'fir';

% Get cutoff frequencys for Filter
%cent_deviation = 200;
% f_interval = get_f_interval(INF,cent_deviation);
% Wn = f_interval/(fs/2);
%
% % Calculate Filter Coefficients
% if strcmp(filter_type,'iir') == true;
%
%     order = 6;
%
%     [B_high,A_high] = butter(order,Wn(1),'high');
%     [B_low,A_low]   = butter(order,Wn(2),'low');
%
% elseif strcmp(filter_type,'fir') == true;
%
%     order = 4096;
%
%     B_high = fir1(order,Wn(1),'high');
%     B_low  = fir1(order,Wn(2),'low');
%     A_high = 1;
%     A_low = 1;
% end

% Filter Signal
%x = filter(B_low,A_low,x);
%x = filter(B_high,A_high,x);

%% Swipe
if param.info == true
    disp('    get_controll_trajectories(): starting swipe calculation');
end
% Paramters for swipe function
% translate hop.size to seconds
hopSec   = param.lHop/param.fs;
dlog2p   = 1/48;                  % swipe default: 1/48
dERBs    = 0.1;                   % swipe default: 0.1
woverlap = .5;                    % swipe default: 0.5
sTHR     = param.F0.minStrength;  % swipe default: -inf

cent = 100;
% every iteration for swipe cent gets multiplicated with this factor
cent_iteration_factor = 3;
% Maximum Iterations for SWIPE Calcluation
maxTry = 3;

% Try to Calculate Swipe with an interval around the two played notes and
% if not then make the interval bigger every interation
%
% Sometimes swipe cant calculate the correct results (e.g. in attack phase
% there is no recognized pitch with enough strength and the alorithm fails
% then for the whole input
for iTry = 1: maxTry
    
    %f_interval = get_f_interval(cent, INF);
    f_interval = [30 3000];
    [swipeVec,swipeT,ps] = swipep(x,fs,f_interval,hopSec,dlog2p,dERBs,woverlap,sTHR);
    
    % Check Result:
    % Known Issue: swipeVec values are all the same (check deviation)
    swipeVec_dev = std(swipeVec);
    ps_sum = sum(ps);
    
    % If deviation smaller than epsilon than we can assume that its false
    if ( swipeVec_dev < 1e-5 || isnan(swipeVec_dev) ) && ps_sum == 0
        %try again with lager cent deviation
        cent = cent * cent_iteration_factor;
        if iTry == maxTry
            if param.info == true
                disp(['    get_controll_trajectories(): Could not find correct' ...
                    ' SWIPE result after maximum Iterations: ' num2str(iTry)]);
            end
        end
    else
        if param.info == true
            disp(['    get_controll_trajectories(): Found correct f0 with SWIPE' ...
                ' after ' num2str(iTry) ' Iterations.']);
        end
        break;
    end
end


features.f0.swipe.f0       = swipeVec;
features.f0.swipe.t       = swipeT;
features.f0.swipe.strength = ps;


%% orchidas pitch collection


[f0_eckf,amp_eckf,phase_eckf,x_est_eckf] = eckf_pitch(x',fs,0.01,1);

features.f0.eckf.f0     = f0_eckf; 
features.f0.eckf.amp    = amp_eckf; 
features.f0.eckf.phase  = phase_eckf;
features.f0.eckf.x_est  = x_est_eckf; 

[t_yin,f0_yin] = yin_estimator(x',fs);

features.f0.yin.t  = t_yin';
features.f0.yin.f0 = f0_yin';


%% RMS
if param.info == true
    disp('    get_controll_trajectories(): starting RMS calculation');
end

pad = zeros(param.lWinRMS,1);
x   = [pad; x; pad];

for frameCount = 1:nWin
    
    frame = x((frameCount-1)*param.lHop - param.lWinRMS/2 + param.lWinRMS: ...
        (frameCount-1)*param.lHop + param.lWinRMS/2 -1  +param.lWinRMS);
    
    features.rmsVec(frameCount) = rms(frame);
    
end

if param.info == true
    disp('    get_controll_trajectories(): finished');
end

end

