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
partStr = zeros(param.PART.nPartials, 1);

% harmonicPart = zeros(size(FRAME));

% allocate the residual and sinusiodal frame for iterative
% cancellation/addition of the sinusoids
residual    = frame;
sinusoidal  = zeros(size(frame));

% estimate all partial frequencies as multiples of f0
estimatedFreqz = (1:param.PART.nPartials)*f0est;

% obtain bin numbers of relevant frequencies
freqPos = round(estimatedFreqz*( param.PART.nFFT/param.fs))+1;

% the search range (TO ONE SIDE)
% is half an octave (half the distance between to peaks)
searchRange = (f0est-f0est *2^(-6/12)) *( param.PART.nFFT/param.fs);


%% LOOP OVER ALL PARTIALS

for partCNT = 1:param.PART.nPartials
    
    % define relevant range
    boundINDS  =  round([freqPos(partCNT)-searchRange freqPos(partCNT)+searchRange]);
    
    
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
        [truePeakHeight, truePeakPos]   = get_peak_hight(FRAMEabs,partInd, param);
        
        % check for badly conditioned interpolation
        if abs(truePeakHeight-FRAMEabs(partInd)) > 0.1
            % and use rough value, if true
           truePeakHeight = FRAMEabs(partInd);
           truePeakPos    = partInd;
        end
        
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
        
        
        
        
        
        % assign parameters if valid  
        if truePeakHeight / max(FRAMEabs) > 0.00001
            
            
            
            % calculate partial frequency:
            % DON'T FORGET THE OFFSET '-1' CAUSED BY MATLAB INDEXING
            partFre(partCNT) = ((truePeakPos-1) * param.fs)/param.PART.nFFT;
            
            % get amplitude
            % MIND THE window correction
            partAmp(partCNT) =  winCorr * truePeakHeight / (param.PART.lWin/2);
            
            % and phase
            partPha(partCNT) = phaseEstimate;
            
            
            %% find correct phase by minimum value solution
            
            
            if param.PART.getPhases == true
                
                partPha(partCNT) = get_phase_min(param, t, partCNT, partAmp, partFre, windowFunction, residual);
                
            end
            
            
            
            %% check relation to previous peaks
            if ~isempty(lastPartials)
                
                % get the strength of each partial
                partStr(partCNT) =  get_partial_strength(param, lastPartials.AMPL(partCNT) , lastPartials.FREQ(partCNT) ,lastPartials.PHAS(partCNT)  , partAmp(partCNT), partFre(partCNT), partPha(partCNT));
         
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
  
            
        else
            
            disp('Peak too weak!')
            
        end
        
    end
    
end


partials.FREQ = partFre;
partials.AMPL = partAmp;
partials.PHAS = partPha;
partials.STRE = partStr;





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

