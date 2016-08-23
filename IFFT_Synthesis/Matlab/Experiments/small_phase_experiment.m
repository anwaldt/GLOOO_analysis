% An experiment to test something with the phase ...
%
%   ... in order to check whether the phase of the 
%   sinusoid in IFFT synthesis is applied correctly.
%   Seems to be OK!
%

clearvars
close all

%% Prepare Spectrum

 lWin = 2^10;
load kernel_data

k = kernels{1};

X = zeros(lWin,1);

X(22:32) = k;

X(22:32) = X(22:32)*exp(-j * 2*pi);

x  = ifft(X,'symmetric');

%% Windows

win1 =  calculate_BH92_complete(lWin) ;
WIN1 =   real(fftshift(    fft(win1) ));

% the time-domain window
win2 = (boxcar(lWin))./win1;


%% Plot

plot(x.*win2)
hold on
line([lWin/2 lWin/2],[-1 1])
hold off