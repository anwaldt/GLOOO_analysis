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

function [f0vec, SMS, noiseSynth,  resVec, tonalVec] = get_partial_trajectories(x, param, f0vec)




nSamples    = length(x);
% calculate the number of frames
nFrames     = floor((nSamples-param.PART.lWin)/param.lHop);

% allocate output vectors
resVec       = zeros(size(x));
noiseSynth  = zeros(nFrames,param.PART.lWin/2);
tonalVec       = zeros(size(x));
nSamples    = length(x);



% allocate memory for sinusoidal parameter trajectories and co
SMS.FRE  = zeros(param.PART.nPartials,nFrames);
SMS.AMP  = zeros(param.PART.nPartials,nFrames);
SMS.PHA  = zeros(param.PART.nPartials,nFrames);


% zero pad input at the end
x = [x;zeros(param.PART.lWin+1,1)];


% set individual start point
frameStart  = 2;
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
for frameIDX = frameStart:nFrames-1
    
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
        f0vec(frameIDX) = f0est;
    else
        f0est = f0vec(frameIDX);
    end
    
    % get partials parameters (if f0 is valid)
    if f0est~=0 && ~isnan(f0est)
        
        % call the main analysis function for each frame
        % and get:
        [tmpPartials,resFrame,sinusoidal] = ...
            get_partial_frame(frame, lastPartials, f0est, param);
        
        SMS.FRE(:,frameIDX) = tmpPartials.FREQ;
        SMS.AMP(:,frameIDX) = tmpPartials.AMPL;
        SMS.PHA(:,frameIDX) = tmpPartials.PHAS;
        
        % calculate the distribution of the residual
        % noiseSynth(idxs)   = noiseSynth(idxs) + get_residual_distribution(residual);
        noiseSynth(frameIDX,:) =  get_residual_distribution(resFrame);
        
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
            resVec(idxs)     = resVec(idxs)+resFrame;%resDist{frameIDX};
            
            % noise_mod(idxs) = noise_mod(idxs)+resDist{frameIDX};
            
            tonalVec(idxs)     = tonalVec(idxs)+sinusoidal;
            
        catch
            disp(  'can#t add')
        end
    else
        
        
        
    end
    
    % increase sample index
    sampleIDX = sampleIDX+param.lHop;
    
    if param.PART.info == true
        disp(['Frame ' num2str(frameIDX) ' of ' num2str(nFrames)]);
    end
end

%% Get statistical values for each partial's f0-deviation
%
%   IS NOT USED, NOW
%
% for partCnt = 1:param.nPartials
%
%     tmp     = partialFre(partCnt,:)/partCnt;
%
%     tmpDev  = partialFre(1,:)./tmp;
%
%     tmpDev(isnan(tmpDev))=[];
%     tmpDev(isinf(tmpDev))=[];
%
%     xx      = linspace(min(tmpDev),max(tmpDev),20);
%     tmpStd  = std(tmpDev);
%     [N,X]   = hist(tmp,xx);
%
%     plot(X,N)
% end

%%

if param.plotit == true
    
    
    figure
    plot(partialFre','g');
    
    figure
    plot(partialAmp')
    
    figure
    plot(f0vec);
    
end