%% [ segMarks ] = intra_note_segmentation(inFile, p)
%
%   Function for detecting significant positions
%   in multi-shot samples.
%
%
%
% Henrik von Coler
% 2014-12-17
%%

function [ segMarks ] = intra_note_segmentation(inFile, p)


[x, fs] = wavread([p.inDir inFile '.wav']);
noise = zeros(size(x));
nSamples = length(x);
 
% calculate the number of frames
nFrames = floor((nSamples-p.lWin)/p.lHop);
sampleIDX = 1;

envVEC  = zeros(nFrames,1);
fluxVEC = zeros(nFrames,1); 
flatVEC = zeros(nFrames,1); 

for frameIDX = 1:nFrames-2
    
    % Get index vectors
    idxs = sampleIDX-(p.lWin/2):sampleIDX+(p.lWin/2)-1;
    
    idxs = idxs(idxs>=1);
    
    if frameIDX ==1
        idxsOLD = idxs;
    end
    
    idxs = idxs(1:length(idxsOLD));
    
    envVEC(frameIDX)  = sum(x(idxs).^2);
    fluxVEC(frameIDX) = spectral_flux_dist(abs(fft(x(idxs)))',abs(fft(x(idxsOLD)))'); 
    flatVEC(frameIDX) = spectral_flatness(abs(fft(x(idxs))));
    
    % increase sample index
    sampleIDX = sampleIDX+p.lHop;
    
    % remember old indices
    idxsOLD = idxs;
end

envVEC  = smooth(envVEC,10);
fluxVEC = smooth(fluxVEC,10);

end

