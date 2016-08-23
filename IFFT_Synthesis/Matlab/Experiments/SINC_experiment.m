%%
%
%   Experiment for finding the right SINC formula
%   for the iift window in ifft-synthesis !
%
% 2014-08-18
% HvC
%



%% BASIC PARAMETERS

% sampling frequency
fs      = 44100;

% synthesis frame length
nFrame  = 2^11;

% time axis within one frame
t = (0:nFrame)/fs;

% hop size in seconds
hop_s  = (nHop/fs);

% delta frequency (bin distance)
df    =  fs/nFrame;


%%
 
nPad = 100;

h = [ zeros(1,nPad) rectpuls(t)  zeros(1,nPad-1)];

H = fft(h)/(max(fft(h)));

H2 = sinc(linspace(0,nFrame,length(h)));


plot(abs(H))
hold on
plot(abs(H2),'r--')
legend('by FFT','in time domain')
hold off