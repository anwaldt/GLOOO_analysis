%% function [FRAME, sinusoid] = place_mainlobe(sinusoid,lWin,fs,kernels,kernels_LF,fracVec,fracVec_LF)
%
%   Creates the spectrum 'FRAME', specified
%   by sinusoid - also takes care of phase
%   management for overlap in the triangular fashion!
%
%
%
%   @TODO:  The LF lobes do not work at all!
%
%
% Henrik von Coler
% 2014-09-23

function [FRAME, sinusoid] = place_mainlobe(sinusoid,lWin,fs,kernels,kernels_LF,fracVec,fracVec_LF)


% delta frequency (bin distance)
df    =  fs/lWin;
% allocate memory
FRAME       = zeros(lWin,1);

%% phase increment stuff

% since we only know the desired phase at 1/4 we have to get it for
% the start for the synthesis - e.g. 'turn it backwards':
sinusoid.thisPhas = sinusoid.lastPhas - 2*pi*sinusoid.f0 * ((lWin/4)/fs);
sinusoid.thisPhas = rem(sinusoid.thisPhas,2*pi);

% Remember the phase at 3/4 for the  next run:
% @TODO: THE +PI in the end is heuristically tuned -
% WHY IS IT LIKE THAT ???
tmpPhas = sinusoid.thisPhas + (2*pi*sinusoid.f0 * (lWin*(3/4)/fs));
tmpPhas = rem(tmpPhas,2*pi);
sinusoid.lastPhas = tmpPhas;

%% bins + freqs

% THE complex SINE:
sinusoid.compSine =    exp(1i * sinusoid.thisPhas);

% 'floating point position' of this partial
sinusoid.fracBin = sinusoid.f0 / df + 1;

% closest bin
centerBin   = floor(sinusoid.fracBin);

% offset
offset      = sinusoid.fracBin-centerBin;

%% "Drop the lobe"

% check whether the lobe of this partial is not 'touching DC'
if centerBin >= 4
    
    % find best matching kernel
    [~,kernelIdx] = min(abs(fracVec-offset));
    
    % PICK KERNEL
    tmpKernel = kernels{kernelIdx};
    
    % SHIFT WINDOW TO POSITION
    for shiftCnt = -5:5
        
        % the fractional position of the window function which has to
        % go there:
        winPos     = ( (lWin/2+1) + shiftCnt) + offset;
        
        % the position in the spectrum which is treated:
        framePos = centerBin - shiftCnt;
        
        % interpolation boundaries:
        lowBound    = floor(winPos) ;
        highBound   = ceil(winPos);
        
        % make shure we are within bounds:
        % TODO: There is a problem with low
        %       frequencies - when the lobe
        %       goes beyond bin 1 --
        if (framePos)>1 && framePos <= lWin
            
            % the window value taken from the kernel:
            interpComp = tmpKernel(6-shiftCnt);%;(1-offset) * WIN(lowBound) + offset * WIN(highBound);
            
            %  apply window to sine
            FRAME(framePos) = FRAME(framePos) + sinusoid.a * sinusoid.compSine  * interpComp;
            
        end
        
    end
    
    % if the lobe touches DC:
else
    
    % find best matching kernel
    [~,kernelIdx] =     min(abs(fracVec_LF- sinusoid.fracBin ));
    
    % PICK KERNEL
    tmpKernel = kernels_LF{kernelIdx};
    
    
    % SHIFT WINDOW TO POSITION
    for shiftCnt = 1:8
        
        % the position in the spectrum which is treated:
        framePos =  shiftCnt;
        
        
        if (framePos)>=1 && framePos <= lWin
            
            % the window value taken from the kernel:
            interpComp = tmpKernel(shiftCnt);%;(1-offset) * WIN(lowBound) + offset * WIN(highBound);
            
            %  apply window to sine
            FRAME(framePos) = FRAME(framePos) + sinusoid.a * sinusoid.compSine  * interpComp;
            
        end
        
    end
    
    
end

