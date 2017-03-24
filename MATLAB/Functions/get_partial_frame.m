%% [partFre, partialAmp, partPha, residualFrame] = ...
%  get_partial_frame(frame, f0est, param.fs, nPartials, nFFT, fMin, fMax,windowFunction);
%
%
%   Get the partial information for one frame.
%   Input should NOT be windowed.
%
%   Henrik von Coler
%   2014-09-02 : 2017-03-24


function    [partFre, partAmp, partPha, residual, sinusoidal] = get_partial_frame(frame, f0est, param)

% the time axis for each frame
t               = linspace(0, (length(frame)-1)/param.fs, length(frame))';
windowFunction  = hanning(length(t));


windowRatio = sum(windowFunction)/sum(ones(size(windowFunction)));

% do the FFT AND apply window
frame       = frame.*windowFunction;
FRAME       = fft(frame, param.nFFT);
FRAME       = FRAME(1:param.nFFT/2);

% prepare amplitude and phase spectrum
% FRAME       = FRAME(1:length(FRAME)/2);

FRAMEabs    = abs(FRAME);
FRAMEpha    = angle(FRAME);


% allocate memory
partFre = zeros(param.nPartials, 1);
partAmp = zeros(param.nPartials, 1);
partPha = zeros(param.nPartials, 1);

% harmonicPart = zeros(size(FRAME));

% allocate the residual and sinusiodal frame for iterative
% cancellation/addition of the sinusoids
residual    = frame;
sinusoidal  = zeros(size(frame));

% estimate all partial frequencies as multiples of f0
estimatedFreqz = (1:param.nPartials)*f0est;

% obtain bins at relevant frequencies
freqPos = round(estimatedFreqz*( param.nFFT/param.fs));

for partCnt = 1:param.nPartials
    
    
    % get boundaries by deviation in cent
    boundaries = [estimatedFreqz(partCnt)*2^(-1/12) estimatedFreqz(partCnt)*2^(1/12) ];
    
    boundINDS  =  round(boundaries*( param.nFFT/param.fs));

    % define relevant range
    tmpIDX = boundINDS(1):boundINDS(2);
    
    % find maximum in relevant range
    tmpIDX = tmpIDX(tmpIDX>0);
    try
        [~, partIndAbsolute] = max(FRAMEabs(tmpIDX));
    catch
        1;
    end
    
    try
        % shift by tmpIDX offset
        partInd = partIndAbsolute+tmpIDX(1)-1;
    catch
        error('Problem getting "partInd" ');
    end
    
    % check peak hight
    [truePeakHeight, truePeakPos]   = get_peak_hight(FRAMEabs,partInd);
    
    
    %     if partInd-1>0 && partInd+1<length(FRAME)
    %         phaseEstimate               = get_peak_phase(FRAME(partInd-1:partInd+1),truePeakPos-partInd);
    %     else
    %         phaseEstimate               = 0;
    %     end
    
    % assign parameters if valid (DISABLED)
    if truePeakHeight/max(FRAMEabs) > 0.00001
        
        % calculate partial frequency:
        % DON'T FORGET THE OFFSET '-1' CAUSED BY MATLAB INDEXING
        partFre(partCnt) = ((truePeakPos-1)*param.fs)/param.nFFT;
        
        % get amplitude
        partAmp(partCnt) = truePeakHeight / (param.lWin*windowRatio);
        
        
        %% find correct phase by minimum value solution
        
        
        if param.getPhases == true
            
            sP              = linspace(-pi,pi,param.nPhaseSteps);
            minValues       = zeros(1,param.nPhaseSteps);
            partialPhase    = zeros(1,param.nPhaseSteps);
            searchInd = 1;
            
            % first rough
            for searchPhase = sP
                
                thisPartial     = partAmp(partCnt) * sin(2*pi*partFre(partCnt).*t + searchPhase ).*windowFunction;
                tmpResidual     = residual - thisPartial;
                
                partialPhase(searchInd) = searchPhase;
                minValues(searchInd)    = sum( (tmpResidual).^2);
                searchInd = searchInd+1;
            end
            
            [~, ind] = min(minValues);
            
            
            partPha(partCnt) = partialPhase(ind);
            
            
            % then fine
            
            %             if ind>1
            %                 lowerBound = partialPhase(ind-1);
            %             else
            %                 lowerBound = partialPhase(end);
            %             end
            %
            %             if ind<param.nPhaseSteps
            %                 upperBound = partialPhase(ind+1);
            %             else
            %                 upperBound = partialPhase(1);
            %             end
            %
            %             sP              = linspace(lowerBound, upperBound, param.nPhaseSteps);
            %             minValues       = zeros(1,param.nPhaseSteps);
            %             partialPhase    = zeros(1,param.nPhaseSteps);
            %             searchInd = 1;
            %
            %             for searchPhase = sP
            %
            %                 thisPartial     = partAmp(partCnt) * sin(2*pi*partFre(partCnt).*t + searchPhase ).*windowFunction;
            %                 tmpResidual     = residual   - thisPartial;
            %
            %                 partialPhase(searchInd) = searchPhase;
            %                 minValues(searchInd)    = sum( (tmpResidual).^2);
            %                 searchInd = searchInd+1;
            %             end
            %
            %             [~, ind] = min(minValues);
            %
            %             partPha(partCnt) = partialPhase(ind);
            
            
        end
        
        
        
        %% resynthesize partial for subtraction
        
        % if the phase has been captured in the time domain :
        % do not use an offset
        generalOffset = 0;
        
        % use this offset if the phase has been captured in the spectrum (center of the frame)
        % generalOffset = 2*pi*partFre(partCnt)*(-(0.5975*length(frame))/param.fs);
        
        thisPartial         = partAmp(partCnt) * sin(2*pi*partFre(partCnt).*t ...
            + generalOffset ...
            + partPha(partCnt)).*windowFunction;
        
        residual            = residual   - thisPartial;
        
        
        
        sinusoidal          = sinusoidal + thisPartial;
        
        
        %% other method: erase spectral peak
        
        
        %     peakBoundaries = [partInd, partInd];
        %
        %     % lower boundary
        %     tmpInd = partInd;
        %     while FRAMEabs(tmpInd) > FRAMEabs(tmpInd-1) && tmpInd>1
        %         tmpInd = tmpInd-1;
        %     end
        %     peakBoundaries(1)=tmpInd;
        %
        %     % upper boundary
        %     tmpInd = partInd;
        %     while FRAMEabs(tmpInd) > FRAMEabs(tmpInd+1)&& tmpInd<length(FRAMEabs)
        %         tmpInd = tmpInd+1;
        %     end
        %
        %     peakBoundaries(2)=tmpInd;
        %
        %     extinctionIndexes = (peakBoundaries);
        %
        %     X2(tmpIDX)= mean(X2(extinctionIndexes) ) ;
        %     X2(length(X2)-tmpIDX)= mean(X2(extinctionIndexes) );
        
    end
    
end



% plot(frame)
% hold on
% plot(sinusoidal,'r')
% hold off

%
% FRAMEup = downsample(FRAMEup,upSamp);
%
%
% residualDistribution = smooth(abs(FRAMEup(1:length(FRAMEup)/2)),10);

%% some plotters for debugging


% plot(real(FRAME)),  hold on, plot(imag(FRAME),'g--'),
% plot(real(fft(sinusoidal,nFFT)),'r'),
% plot(imag(fft(sinusoidal,nFFT)),'m--'),
% hold off, xlim([0,1000])

% figure
% plot(abs(fft(frame))), hold on,
% plot(abs(fft(residual)),'r--'),
% xlim([0,500]), hold off
% legend({'original','residual'});

% plot(FRAMEabs), hold on,
% plot(abs(fft(sinusoidal,nFFT)),'r'), hold off,
% xlim([0,1000])

% plot((FRAMEpha)), hold on, plot((angle(fft(sinusoidal,nFFT))),'r'), hold off, xlim([0,1000])

% plot(frame), hold on, plot(thisPartial,'r'), hold off

% plot(frame), hold on, plot(sinusoidal,'r'), hold off

% plot(frame), hold on, plot(residual,'r'), hold off

% plot(sinusoidal,'g'), hold on, plot(residual,'r'), hold off


