%% get_partial_trajectories(inFile, p)
%
%   This function  should also extract the residual and so on
%   is designed to work only for (single shot) samples which have
%   a global fundamental frequency.
%
%
%   Henrik von Coler
%   2014-12-10
%%

function [f0vec, SMS, noiseSynth,  resVec, tonalVec] = get_partial_trajectories(x, param, CTL)




nSamples    = length(x);
% calculate the number of frames
nFrames     = floor((nSamples-param.PART.lWin)/param.lHop);

% allocate output vectors
resVec       = zeros(size(x));
noiseSynth  = zeros(nFrames,param.PART.lWin);
tonalVec       = zeros(size(x));
 
% allocate memory for sinusoidal parameter trajectories and co
SMS.FRE  = zeros(param.PART.nPartials,nFrames);
SMS.AMP  = zeros(param.PART.nPartials,nFrames);
SMS.PHA  = zeros(param.PART.nPartials,nFrames);


% zero pad input at the end
x = [x;zeros(param.PART.lWin+1,1)];


% set individual start point
frameStart  = 2;

% sample index is always the center of the analysis window
sampleIDX   = 1;

if frameStart~= 1
    sampleIDX = sampleIDX+(frameStart*param.lHop);
end

if nargin<3
    
    f0vec       = zeros(nFrames,1);
    
    % get global f0
    f0_global = get_f0_autocorr(x, param.fs, param.upsampFactor,param.fMin, param.fMax);
    
    % we search for the instantaneous f0 within +/- two semitones
    f0_min = f0_global * 2^(-2/12);
    f0_max = f0_global * 2^(2/12);
    
    % this is ok, too:
    % f0_min = param.fMin;
    % f0_max = param.fMax;
    
end

lastPartials = [];

%% LOOP over all frames

% Variables for Info output
percent_done        = 5;
percent_interval    = 10;


disp(['Using ' param.F0.f0Mode ' for partial tracking!']);


for frameCNT = frameStart:nFrames-1
   
     if param.PART.info == true && floor(frameCNT/nFrames*10000)/100 > percent_done        
        disp(['    Frame: ' num2str(frameCNT) ', ' num2str(floor(frameCNT/nFrames*10000/100)) '% done']);
        percent_done = percent_done + percent_interval;
    end
 
    % Get index vectors
    idxs        = sampleIDX-(param.PART.lWin/2):sampleIDX+(param.PART.lWin/2)-1;
    idxsPEAK    = sampleIDX-(param.PART.lWin/2):sampleIDX+(param.PART.lWin/2)-1;

    % get frame
    if isempty(find(idxsPEAK(idxsPEAK<1), 1))
        frame       = x(idxs);
        %         framePEAK   = x(idxsPEAK);
        % if frame is out of bounds -> zero pad !!
    else
        idxs        = idxs(idxs>=1);
        %         idxsPEAK    = idxsPEAK(idxsPEAK>=1);
        
        frame       =  [ zeros(param.PART.lWin-length(idxs),1); x(idxs)];
        %         framePEAK   = [ zeros(param.lWinSynthPEAK-length(idxsPEAK),1); x(idxsPEAK)];
    end
    
    % window the frame
    %     frame       = frame .* hanning(length(frame));
    %     framePEAK   = framePEAK .* hanning(length(framePEAK));
    
    % get f0 value - ONLY if no trajectory has been handed over to the
    % algo!
    if nargin<3
        f0est           = get_f0_autocorr_peakpick(frame, param.fs, param.upsampFactor,f0_min, f0_max);
        f0vec(frameCNT) = f0est;

    else
        
        
        t = sampleIDX/param.fs;
        
               
        switch param.F0.f0Mode            
            
            case 'yin'
                
                % get index of nearest support point in f0
                [~, tmpIdx] = min(abs(CTL.f0.yin.t-t));
                
                % pick f0 value at index
                f0est = CTL.f0.yin.f0(tmpIdx+1);
                
            case 'swipe'
                
                % get index of nearest support point in f0
               [~, tmpIdx] = min(abs(CTL.f0.swipe.t-t));
                
                % pick f0 value at index
                f0est = CTL.f0.swipe.f0(tmpIdx);
                
        end
        
        f0vec(frameCNT) = f0est;
    end
    
    % get partials parameters (if f0 is valid)
    if f0est~=0 && ~isnan(f0est)
        
        % call the main analysis function for each frame
        % ONLY if the pitch strength is above threshold
        
        if CTL.f0.swipe.strength(frameCNT) > param.PART.psThresh
            
            [tmpPartials,resFrame,sinusoidal] = ...
                get_partial_frame(frame, lastPartials, f0est, param);
        
        else
            
            resFrame = frame;
            
            % resFrame = zeros(size(frame));

            sinusoidal = zeros(size(frame));
            tmpPartials.FREQ = zeros(param.PART.nPartials,1);
            tmpPartials.AMPL = zeros(param.PART.nPartials,1);
            tmpPartials.PHAS = zeros(param.PART.nPartials,1);
            tmpPartials.STRE = zeros(param.PART.nPartials,1);
        end
        
        lastPartials = tmpPartials;
        
        SMS.FRE(:,frameCNT) = tmpPartials.FREQ;
        SMS.AMP(:,frameCNT) = tmpPartials.AMPL;
        SMS.PHA(:,frameCNT) = tmpPartials.PHAS;
        SMS.STR(:,frameCNT) = tmpPartials.STRE;
   
        
        % calculate the distribution of the residual
        % noiseSynth(idxs)   = noiseSynth(idxs) + get_residual_distribution(residual);
        %noiseSynth(frameCNT,:) =  get_residual_distribution(resFrame);
                
        noiseSynth(frameCNT,:) =   resFrame;
                

        %% reassamble residual
        %         if length(idxsPEAK)<param.lWinSynthPEAK
        %             FRAMEres = FRAMEres(1:length(idxsPEAK));
        %         else
        %             try
        %                 noise(idxsPEAK) = noise(idxsPEAK)+FRAMEres.*hanning(param.lWinSynthPEAK);
        %             catch
        %                 'LENGTH ERROR';
        %             end
        %         end
        
        
        %         FRAMEres    = smooth(FRAMEres,20);
        %         FRAMEres    = downsample(FRAMEres,param.nFFT/length(frame));
        %         frameRes    =  fftshift(real(ifft(FRAMEres,'symmetric')));
        %         noise(idxs) = noise(idxs)+frameRes;%.*(triang(length(frame)));
        
        try
            % assemble the "true" noise
            resVec(idxs)     = resVec(idxs) + resFrame;%resDist{frameIDX};
            
        catch ME           
%             disp(['    get_partial_trajectories(): cant add:  - ' ME.message]);
%             disp(['    -> resVec frame:'  num2str(frameCNT) ...
%                 ' - idxs(end): ' num2str(idxs(end)) ...
%                 ' - size(resFrame): ' num2str(size(resFrame))]);
                
        end

        try
            % noise_mod(idxs) = noise_mod(idxs)+resDist{frameIDX};            
            tonalVec(idxs)     = tonalVec(idxs) + sinusoidal;
            
        catch ME
%             disp(['    get_partial_trajectories(): cant add: - ' ME.message]);
%             disp(['    -> tonalVec frame:' num2str(frameCNT) ...
%                 ' - idxs(end): ' num2str(idxs(end)) ...
%                 ' - size(resFrame): ' num2str(size(resFrame))]);
                
        end            
    else
        
        
        
    end
    
    % increase sample index
    sampleIDX = sampleIDX + param.lHop;
    
    
   
end


%%

if param.plotit == true
    
    
    figure
    plot(partialFre','g');
    
    figure
    plot(partialAmp')
    
    figure
    plot(f0vec);
    
end