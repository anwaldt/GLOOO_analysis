% soma_filter().m
%
%
%
% Author: Henrik von Coler
% Edited: 2016-08-11

function [out] = soma_filter(in, tresh)
 

% allocate result vector:
diffValTrack = zeros(size(in));

% append a leading zero:
% in  = [in];

% vector for calculations
out   = in;


%% stage 1

% how many samples look ahead ?
nSteps = 1;

% previously hard coded value:
%tresh1 = 0.2;


m = mean(in);
s = std(in);

tresh1 = s*tresh;

offset_memory = 0;

% loop over all samples of the trajectory
for i=2:length(in) 
    
    % get relative (absolute) distance
    % of succesive f0-samples
    diffVal             = ((in(i)-in(i-1)));
    relDiffVal          = diffVal/((in(i)+in(i-1))/2);
    
    diffValTrack(i)     = relDiffVal;
    
    % either drag the following samples down by the differece between the
    % samples or by the value of the second sample
    % -> the latter is more robust concerning vibrato
    
    % eliminate jumps greater than treshold
    % by shifting all following samples by
    % amount of relevant jumps
    
    
    if abs(diffVal) > tresh1
        offset_memory = offset_memory+diffVal;
    end
        
   
    out(i) = in(i)-offset_memory;
end

% remove leading zero:
% out(1) = [];

