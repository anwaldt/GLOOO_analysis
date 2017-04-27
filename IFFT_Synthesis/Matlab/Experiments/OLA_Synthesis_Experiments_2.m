%%
%
% another time-domain approach
%
%

close all
clearvars

%% BASIC PARAMETERS

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 100;

% synthesis frame length
nFrame  = 2^11;

% synthesis hop size
nHop    = nFrame/2;

% hop size in seconds
hop_s  = (nHop/fs);

% time axis within one frame
t = (0:nFrame-1)/fs;


%% Windows
close all

% just one window for the overlap add 
win =  hann(nFrame) ;
 
figure
plot(win)
shg

%% SINUSOIDAL PARAMETERS

close all

s.f0  = 441.36; %10.87/hop_ms;
s.a   = 1;
s.phi = 0;

fVib = 10;
aVib = 0.5;

% the modulation trajectory
F0  = s.f0 + aVib* s.f0 * sin(2*pi*fVib*(1:nFrames+1)/hop_s);

 
plot(abs(fft(sin(2*pi*s.f0*t))),'m');

figure
plot(F0)

%% Synthesis LOOP
 
Y   = {};

for i=1:nFrames
    
    if i==1
        tmpF0 =  linspace(F0(i),F0(i+1),nFrame);
        tmpPHI = tmpF0 .* t;
    else
        tmpF0(1:nFrame/2) = lastF0(nFrame/2+1:end);
        tmpF0(nFrame/2+1:end) = linspace(F0(i),F0(i+1),nFrame/2);
        tmpPHI = tmpF0 .* t;
    end
    
    tmpFrame =  sin(2*pi*  tmpPHI)';
    
    Y{i} =  tmpFrame;
   
    
%   plot(tmpFrame)
    
%     hold on
%     FRAME = abs(fft(tmpFrame));
%     %     plot(real(cFRAME),'g');
%     %     plot(imag(cFRAME),'r');
%     plot(abs(FRAME),'--');
%     
%     hold off
%     
    % UPDATE the PHASE
    s.phi =   rem( s.phi + (F0(i) * hop_s) * (2*pi),2*pi);
    
    lastF0 = tmpF0;
    
end

%%

out = zeros(nFrames*nHop+nFrame,1);
figure
hold on

for i=1:nFrames
    
    inds = i*nHop:i*nHop+nFrame-1;
 
    out(inds) =     out(inds) + Y{i}.*win ;
    
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
    y(inds) =     y(inds) + Y{i}.*win ;
    
    subplot(nPlots,1,i);    
    plot(y)
end