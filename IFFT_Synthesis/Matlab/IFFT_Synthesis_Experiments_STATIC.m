 %% IFFT_Analysis_Experiments_STATIC.m
%
%   Frequency-domain (IFFT) synthesis
%   with static fundamental frequency.
%   
%   Works!
%
%   Henrik von Coler
%   2014-08-20

close all
clearvars

%% BASIC PARAMETERS

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 200;

% synthesis frame length
nFrame  = 2^11;

% synthesis hop size
nHop    = nFrame/8;

% hop size in seconds
hop_s  = (nHop/fs);

% time axis within one frame
t = (0:nFrame-1)/fs;

% delta frequency (bin distance)
df    =  fs/nFrame;

%% Windows

close all

% upsample the Window for better interpolation
resFactor = 1;

% for time truncation
%ww2 = hann(nFrame).^0.1;


% triangular with FFT
win =  calculate_BH92_complete(nFrame) ;
% making it symmetric gets the FD window real
%WIN = fftshift(  ifft(win,'symmetric'));

WIN =  fftshift(    fft(win) );
%WIN = 0.5*sinc(linspace(-nFrame/2, nFrame/2-1,nFrame*resFactor))';
%  win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
%   win = ones(nFrame,1);
%   WIN = fftshift(  fft(win));


figure
plot(abs(WIN),'g')
hold
plot(imag(WIN),'r')

figure
plot(win)
shg



%% SINUSOIDAL PARAMETERS

nPart = 12;
close all

for partCnt=1:nPart
    s(partCnt).f0  = 4.15*df * partCnt; %10.87/hop_ms;
    s(partCnt).a   = 1/(partCnt);
    s(partCnt).phi =  rand*pi;
    
    
    % 'floating point bin' of this frequency
    s(partCnt).bin = s(partCnt).f0 / df +1;
    
    plot(abs(fft(   sin(2*pi*s(partCnt).f0*t)' .*win  )),'m');
    
end


%% Framewise synthesis

Y   = [];

for i=1:nFrames
    
    FRAME       = zeros(nFrame,1);
    
    
    for partCnt = 1:nPart
        
        centerBin   = round(s(partCnt).bin);
        offset      = s(partCnt).bin-centerBin;
        
        % THE SINE in this frame
        thisSine =  nFrame/2 *  exp(1i * s(partCnt).phi);
        
        % SHIFT WINDOW TO POSITION
        for cc=     -20:20
            
            thisPos     = (nFrame/2 +1 + cc + offset)*resFactor;
            lowBound    =  floor(thisPos) ;
            highBound   = ceil(thisPos);
            
            if((centerBin +cc)>=1)
                
                % OLD: read value from previously calculated sinc function
                FRAME(centerBin +cc) = FRAME(centerBin +cc)+  s(partCnt).a * thisSine  * ...
                    (1-offset) * WIN(lowBound) + offset * WIN(highBound);
                
                
                % NEW: directly get SINC value
                % FRAME(centerBin +cc) = thisSine  * get_window_at(thisPos);
            end
            
        end
        
        % UPDATE the PHASE
        s(partCnt).phi =   rem( s(partCnt).phi + (s(partCnt).f0 * hop_s) * (2*pi),2*pi);
        
        
    end
    % plot the real-imag decomposition
    % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
    
    % plot the complex frame
    plot(abs(FRAME))
    
    tmpFrame    =  1/nFrame * (ifft(FRAME,'symmetric'))./win;
    Y           = [Y tmpFrame];
    
%     plot(tmpFrame)
    
    hold on
    
    plot(abs(FRAME),'--');
    
    hold off
    
    
end

%% Assemble output

out = zeros(nFrames*nHop+nFrame,1);
figure
hold on

for i=1:nFrames
    
    inds = i*nHop:i*nHop+nFrame-1;
    
    out(inds) =     out(inds) + Y(:,i).*win /8;
    
end

figure
plot(out)

%%

nPlots = 4;
figure
hold on

for i=1:nPlots
    
    y = zeros(nPlots*nHop+nFrame,1);
    
    inds = i*nHop:i*nHop+nFrame-1;
    y(inds) =     y(inds) + Y(:,i).*win ;
    
    subplot(nPlots,1,i);
    plot(y)
end




