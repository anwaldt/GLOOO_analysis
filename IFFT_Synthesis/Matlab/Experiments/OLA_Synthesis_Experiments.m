%%
%
% time-domain overlap add synthesis
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

fVib = 1;
aVib =  0.05;

% the modulation trajectory
F0  = s.f0 + aVib* s.f0 * sin(2*pi*fVib*(1:100)/hop_s);

 
plot(abs(fft(   sin(2*pi*s.f0*t)   )),'m');

figure
plot(F0)

%% Synthesis LOOP
 

Y   = {};

for i=1:nFrames
    
    
    tmpFrame =  sin(2*pi* F0(i) * t + s.phi)';
    
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