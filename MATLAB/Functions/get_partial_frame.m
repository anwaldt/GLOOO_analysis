%% [partFre, partialAmp, partPha, residualFrame] = ...
%  get_partial_frame(frame, f0est, param.fs, nPartials, nFFT, fMin, fMax,windowFunction);
%
%
%   Get the partial information for one frame.
%
%   Henrik von Coler
%   2014-09-02 : 2015-01-19


function    [partials, residual, sinusoidal] = get_partial_frame(frame, lastPartials, f0est, param)


%% PREPARE

% the time axis for each frame
t               = linspace(0, (length(frame)-1)/param.fs, length(frame))';
windowFunction  = hanning(length(t));
% this is needed for amplitude correction in the partials:
winCorr         =  length(windowFunction)/sum(windowFunction);


% apply window and do the FFT
frame       = frame.*windowFunction;
FRAME       = fft(frame, param.PART.nFFT);
FRAME       = FRAME(1:param.PART.nFFT/2);

% prepare amplitude and phase spectrum
% FRAME       = FRAME(1:length(FRAME)/2);

FRAMEabs    = abs(FRAME);
FRAMEpha    = angle(FRAME);


% allocate memory
partFre = zeros(param.PART.nPartials, 1);
partAmp = zeros(param.PART.nPartials, 1);
partPha = zeros(param.PART.nPartials, 1);

% harmonicPart = zeros(size(FRAME));

% allocate the residual and sinusiodal frame for iterative
% cancellation/addition of the sinusoids
residual    = frame;
sinusoidal  = zeros(size(frame));

% estimate all partial frequencies as multiples of f0
estimatedFreqz = (1:param.PART.nPartials)*f0est;

% obtain bin numbers of relevant frequencies
freqPos = round(estimatedFreqz*( param.PART.nFFT/param.fs))+1;

%% LOOP OVER ALL PARTIALS

for partCNT = 1:param.PART.nPartials
    
    % define relevant range
    boundaries = [estimatedFreqz(partCNT)*2^(-1/12) estimatedFreqz(partCNT)*2^(1/12) ];
    
    boundINDS  =  round(boundaries*( param.PART.nFFT/param.fs));
    
    
    % define relevant range
    tmpIDX = boundINDS(1):boundINDS(2);
    
    % find maximum in relevant range
    tmpIDX = tmpIDX(tmpIDX>0);
    
    if ~isempty(tmpIDX) && max(tmpIDX) < length(frame)
        
        try
            [~, partIndAbsolute] = max(FRAMEabs(tmpIDX));
        catch
            error('DAMN, can not get peak heigth!');
        end
        
        try
            % shift by tmpIDX offset
            partInd = partIndAbsolute+tmpIDX(1)-1;
        catch
            error('Problem getting "partInd" ');
        end
        
        % check peak hight
        [truePeakHeight, truePeakPos]   = get_peak_hight(FRAMEabs,partInd);
        
        if truePeakHeight <0 || truePeakPos<1
            truePeakHeight=0;
        end
        
        if partInd-1>0 && partInd+1<length(FRAME)
            phaseEstimate               = get_peak_phase(FRAME(partInd-1:partInd+1),truePeakPos-partInd);
        else
            phaseEstimate               = 0;
        end
        
        if ~isempty(lastPartials)
            1;
        end
        
        
        % assign parameters if valid (DISABLED)
        if truePeakHeight/max(FRAMEabs) > 0.00001
            
            % calculate partial frequency:
            % DON'T FORGET THE OFFSET '-1' CAUSED BY MATLAB INDEXING
            partFre(partCNT) = ((truePeakPos-1)*param.fs)/param.PART.nFFT;
            
            % get amplitude
            % MIND THE window correction
            partAmp(partCNT) =  winCorr*truePeakHeight/(param.PART.lWin/2);
            
            % and phase
            partPha(partCNT) = phaseEstimate;
            
            %% find correct phase by minimum value solution
            
            
            if param.PART.getPhases == true
                
                sP              =  linspace(-pi,pi,param.PART.nPhaseSteps);
                minValues       = zeros(1,param.PART.nPhaseSteps);
                partialPhase    = zeros(1,param.PART.nPhaseSteps);
                searchInd = 1;
                
                % first rough
                for searchPhase = sP
                    
                    thisPartial     = partAmp(partCNT) * sin(2*pi*partFre(partCNT).*t + searchPhase ).*windowFunction;
                    tmpResidual     = residual   - thisPartial;
                    
                    partialPhase(searchInd) = searchPhase;
                    minValues(searchInd)    = sum( (tmpResidual).^2);
                    searchInd = searchInd+1;
                end
                
                [~, ind] = min(minValues);
                
                
                partPha(partCNT) = partialPhase(ind);
                
                
                % then fine
                
                if ind>1
                    lowerBound = partialPhase(ind-1);
                else
                    lowerBound = partialPhase(end);
                end
                
                if ind<param.PART.nPhaseSteps
                    upperBound = partialPhase(ind+1);
                else
                    upperBound = partialPhase(1);
                end
                
                sP              = linspace(lowerBound, upperBound, param.PART.nPhaseSteps);
                minValues       = zeros(1,param.PART.nPhaseSteps);
                partialPhase    = zeros(1,param.PART.nPhaseSteps);
                
                searchInd = 1;
                
                for searchPhase = sP
                    
                    thisPartial     = partAmp(partCNT) * sin(2*pi*partFre(partCNT).*t + searchPhase ).*windowFunction;
                    tmpResidual     = residual   - thisPartial;
                    
                    partialPhase(searchInd) = searchPhase;
                    minValues(searchInd)    = sum( (tmpResidual).^2);
                    searchInd = searchInd+1;
                end
                
                [~, ind] = min(minValues);
                
                partPha(partCNT) = partialPhase(ind);
                
                
            end
            
            
            
            %% resynthesize partial for subtraction
            
            % if the phase has been captured in the time domain :
            % do not use an offset
            generalOffset = 0;
            
            % use this offset if the phase has been captured in the spectrum (center of the frame)
            % generalOffset = 2*pi*partFre(partCnt)*(-(0.5975*length(frame))/param.fs);
            
            thisPartial         = ...
                partAmp(partCNT) ...                    Amplitude
                * sin(2*pi*partFre(partCNT).*t ...
                + generalOffset ...
                + partPha(partCNT))...
                .*windowFunction;
            
            % create residual by subtracting partials
            residual            = residual - thisPartial;
            
            % assemble sinusoidal by adding
            % mind the amplitude correction and the *0.25
            sinusoidal          = sinusoidal + 0.25*thisPartial./winCorr;
            
            
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
    
end


partials.FREQ = partFre;
partials.AMPL = partAmp;
partials.PHAS = partPha;





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

