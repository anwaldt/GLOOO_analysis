%% get_residual_trajectories()
%
%   This function gets the residual frames
%   and outputs the Bark band energies.
%
%
%   Henrik von Coler
%   2018-11-05
%%

function [BET] = get_residual_trajectories(noiseFrames, param, CTL)

nFrames     = size(noiseFrames,1);
C           = make_bark_filterbank(param.fs,3);
nBands      = length(C);

% bark energy trajectories
BET = zeros(nFrames,nBands);
   
for frameCNT =1:nFrames

    tmpFrame = noiseFrames(frameCNT,:);
        
    for bandCNT = 1:nBands    
          
        tmpVal = sum(abs(filter(C{bandCNT}.b, C{bandCNT}.a, tmpFrame)))/length(tmpFrame);
        
        
        BET(frameCNT,bandCNT) = tmpVal;
               
    end
end