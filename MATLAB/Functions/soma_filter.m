% soma_filter().m
%
%
%
% Author: Henrik von Coler
% Edited: 2016-08-11

function [ f0_ac ] = soma_filter( f0_Raw )
 

% allocate result vector:
diffValTrack = zeros(size(f0_Raw));

% append a leading zero:
f0_Raw  = [0;f0_Raw];

% vector for calculations
f0_ac   = f0_Raw;


%% stage 1

% how many samples look ahead ?
nSteps = 1;
tresh1 = 0.2;

% loop over all samples of the trajectory
for i=1:length(f0_Raw)-nSteps
    
    % get relative (absolute) distance
    % of succesive f0-samples
    diffVal             = (f0_ac(i+nSteps)-f0_ac(i));
    relDiffVal          = diffVal/((f0_Raw(i+1)+f0_Raw(i))/2);
    diffValTrack(i)     = relDiffVal;
    
    % either drag the following samples down by the differece between the
    % samples or by the value of the second sample
    % -> the latter is more robust concerning vibrato
    
    % eliminate jumps greater than treshold
    % by shifting all following samples by
    % amount of relevant jumps
    
    if abs(relDiffVal) > tresh1
        f0_ac(i+1:end) = f0_ac(i+1:end)-f0_ac(i+1);
    end
    
end

% remove leading zero:
f0_ac(1) = [];

