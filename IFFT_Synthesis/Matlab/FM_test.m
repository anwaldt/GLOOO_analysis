%%   
%
%   A trial for shifting mainlobes according to FM !
%
%   2015-02-13
%
%% Basic setup

close all
clearvars

restoredefaultpath
addpath Functions/

%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
plotit  = 1;

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 1;

% synthesis frame length
lWin    = 2^9;

% synthesis hop size
nHop    = lWin/4;

% hop size in seconds
hop_s   = (nHop/fs);

% time axis within one frame
t       = (0:lWin-1)/fs;

% delta frequency (bin distance)
df      =  fs/lWin;

%% Windows

close all

% upsample the Window for better interpolation
resFactor = 1;

% for time truncation

% win = hann(lWin);

win =  calculate_BH92_complete(lWin) ;

WIN =   real(fftshift(fft(win) ));

% WIN = 0.5*sinc(linspace(-lWin/2, lWin/2-1,lWin*resFactor))';
% win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
% win = ones(lWin,1);
% WIN = fftshift(  fft(win));


figure
plot(real(WIN),'g')
hold
plot(imag(WIN),'r')
plot(abs(WIN),'b--')

% figure
% plot(win)
% shg

%% Control Parameters

vibDepth    = 0;
fVib        = 2;


F0          = linspace(40,41,nFrames);
% plot(F0);shg


%%

s.a   = 1;
s.phi = 0;% rand*pi;


%% SLOPE (FM) parameter

% maximum difference in frequency (measured at the frame boundaries)
maxOff  = 0.1;

% Number of FM-gradients captured
nSlopes = 2;

%% Framewise synthesis

if plotit==1
    figure('units','normalized','outerposition',[0 0 1 1])
end

out         = zeros(nFrames*nHop+lWin,1);

fracVec     = zeros(1,nFrames);
kernels     = cell(nSlopes,nFrames);

slopeVec    = linspace(0, maxOff, nSlopes);

 
%% no mod:


slopeCnt = 1;

frameCnt = 1;



fm = linspace(1-slopeVec(slopeCnt),1+slopeVec(slopeCnt),lWin);

% partial frequency
s.f0        = F0(frameCnt)*fm*df;
tmpFrame    = sin(2*pi.*s.f0.*t +s.phi)'.*win;
FRAME       = fft(tmpFrame);
% THE complex SINE:

% 'floating point position' of this partial
s.fracBin   = (F0(frameCnt)*df) / df;

%     tmpFrame    =  1/lWin * (ifft(FRAME,'symmetric'));


%% MOD 


slopeCnt = 2;

frameCnt = 1;



fm = linspace(1-slopeVec(slopeCnt),1+slopeVec(slopeCnt),lWin);

% partial frequency
s.f0        = F0(frameCnt)*fm*df;
tmpFrame    = sin(2*pi.*s.f0.*t +s.phi)'.*win;
FRAMEfm       = fft(tmpFrame);
% THE complex SINE:

% 'floating point position' of this partial
s.fracBin   = (F0(frameCnt)*df) / df;

%     tmpFrame    =  1/lWin * (ifft(FRAME,'symmetric'));


%% THE SHIFTed SIGNAL

win3        = gausswin(21)*21;

xxx         = zeros(lWin,1);

posOffset   =  s.fracBin *maxOff+1;

posOffFrac  = rem(posOffset,1);
posOffInt   = posOffset-posOffFrac;

p1          = 1-posOffFrac;
p2          = posOffFrac;

xxx( (posOffInt))      =p1;
xxx( (posOffInt)+1)      =p2;
% xxx(110)=0.5;

plot(xxx);

FRAMEshift = conv(FRAME,xxx);
FRAMEshift = conv(FRAMEshift,win3);


%%


% FRAMEWISE ANIMATION

if plotit==1
    
    % plot the  frame
    subplot(3,2,1)
    plot(real(FRAME(1:100)),'r')
    hold on
    plot(imag(FRAME(1:100)),'g')
    plot(abs(FRAME(1:100)))
    plot(abs(FRAMEshift(1:100)),'m--')
    %             hold off
        % plot the real-imag decomposition
    % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
    ylim([-100 100]);
    xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
    title('Spectral Frame (zoom)')
    
   
        subplot(3,2,2)
        plot(xxx)
title('shift signal')
    xlim([0 100]);
    
    
      % plot the  frame
    subplot(3,2,3)
    plot(real(FRAMEfm(1:100)),'r')
    hold on
    plot(imag(FRAMEfm(1:100)),'g')
    plot(abs(FRAMEfm(1:100)))
     %             hold off
        % plot the real-imag decomposition
    % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
    ylim([-100 100]);
    xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
    title('Spectral Frame (zoom)')
    
   
    subplot(3,2,4)
   plot(win3);
   
    
       % plot the  frame
    subplot(3,2,5)
     plot(real(FRAMEshift(1:100)),'r')
    hold on
    plot(imag(FRAMEshift(1:100)),'g')
    plot(abs(FRAMEshift(1:100)))
    %             hold off
        % plot the real-imag decomposition
    % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
    ylim([-100 100]);
    xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
    title('Spectral Frame (zoom)')
    
    
 
    
end




