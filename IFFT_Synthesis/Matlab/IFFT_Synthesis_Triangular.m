%% IFFT_Synthesis_Triangular.m
%
%   Frequency-domain (IFFT) synthesis
%   with varying fundamental frequency,
%   using the pre-calculated main-lobe kernels.
%
%   This follows the 'Rodet-Style', using the triangular window
%   in the time domain + the (1/4):(3/4) phase condition!
%
%   Working!
%
%   Henrik von Coler
%   2014-09-16

close all
clearvars

libPath = '/media/henrikvoncoler/HVC/F0_Estimation_COPY';

% if exist('get_f0_autocorr_peakpick.m')
p = genpath(libPath);
addpath(p)
p = genpath('/media/henrikvoncoler/HVC/F0_Estimation/');
addpath(p);
% end

%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
animate = 0;
plotit  = 1;

% calculate the actual F0 trajectory?
% SLOW !
checkF0 = 1;

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 200;

% synthesis frame length
lWin  = 2^11;

% synthesis hop size
lHop    = lWin/2;

% hop size in seconds
hop_s  = lHop/fs;

% time axis within one frame
t = (0:lWin-1)/fs;

% delta frequency (bin distance)
df    =  fs/lWin;

%% Windows

close all


% the frequency domain window:
win1 =  calculate_BH92_complete(lWin) ;
% This is not needed anymore - it is in the kernels:
% WIN1 =  real(fftshift(    fft(win1) ));

% the time-domain window
win2 = (triang(lWin))./win1;
% win2 = ones(size(win1))./win1;


if plotit==1
    
    % figure
    plot(win1)
    shg
    hold
    plot(win2,'r')

end

%% F0-Control Parameters

% Vibrato
vibDepth = 0.01;
fVib     = 40;
F0       = 100*(ones( 1,nFrames) + vibDepth * sin((1:nFrames)/(fs/lHop)*fVib));

% linear chirp
%F0     = linspace(200,1000,nFrames);

% F expressed in terms of the delta_f
%F0     = linspace(6.1*(fs/lWin),36.4*(fs/lWin),nFrames);

% allocate momory for the measured F0 trajectory
F0meas = zeros(size(F0));

%% Amplitude-Control Parameters

nPart    = 10;
ampDepth =0.5;

for partCnt=1:nPart
    
%     A(partCnt,:)   = rem(partCnt,3)* (1/partCnt)  * (ones(1,nFrames) + ampDepth * sin((1:nFrames)/(fs/lHop)*fVib*rand+rand*pi));
    
        A(partCnt,:)   = ( (nFrames:-1:1)/nFrames).^(4*partCnt);
end

if plotit ==1
    
    figure
    hold on
    
    for i=1:nPart
        plot(A')
    end
    
end

%% Load kernel data

load kernel_data
load kernel_data_LF

%% Framewise synthesis

if animate==1
    figure('units','normalized','outerposition',[0 0 1 1])
end

out = zeros(nFrames*lHop+lWin,1);

for frameCnt=1:nFrames
    
    FRAME = zeros(lWin,1);
    
    % loop over all partials
    for partCnt = 1:nPart
        
        % partial frequency (is always exactly N*f0)
        s(partCnt).f0  = F0(frameCnt) * partCnt;
        
        %
        s(partCnt).a   = A(partCnt,frameCnt);
        
        % start with zero-phase (OR RANDOM)
        if frameCnt==1
            s(partCnt).thisPhas    = rand*pi;
            s(partCnt).lastPhas    = rand*pi;
            s(partCnt).compSine =    1;
            % 'floating point position' of this partial
            s(partCnt).fracBin =1;
        end
        
        % add this partial to the spectrum
        [tmpFrame, s(partCnt)] = place_mainlobe( s(partCnt),lWin,fs,kernels,kernels_LF,fracVec, fracVec_LF);
        FRAME    = FRAME+tmpFrame./4;
        
    end
    
    % transform
    tmpFrame  =  (ifft(FRAME,'symmetric'));
    
    % get rid of the BH-window in time-domain and apply triangular window
    tmpFrame  = tmpFrame.*win2;
    
    % OLA' it
    inds      = ((frameCnt-1)*lHop +1) : ((frameCnt-1)*lHop+lWin);
    out(inds) = out(inds) + tmpFrame ;
    
    if checkF0==1
        F0meas(frameCnt) = get_f0_autocorr(tmpFrame,fs,10,10,4000);
    end
    
    % FRAMEWISE ANIMATION ?
    if animate==1
        
        % plot the  frame
        subplot(2,2,1)
        plot(real(FRAME(1:50)),'r')
        hold on
        plot(imag(FRAME(1:50)),'g')
        plot(abs(FRAME(1:50)))
        hold off
        % plot the real-imag decomposition
        % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
        ylim([-100 200]);
        xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
        title('Spectral Frame (zoom)')
        
        
        subplot(2,2,2)
        plot(tmpFrame)
        ylim([-1 1]);
        xlabel('Sample'), ylabel('x[i]')
        title('Frame in Time Domain');
        
        
        subplot(2,2,3)
        plot(F0,'r')
        hold on
        plot(F0meas,'g--')
        
        legend({'Aspired' , 'Measured'});
        YY = ylim();
        line([frameCnt,frameCnt], [YY(1) YY(2)])
        hold off
        xlabel('Frame Index'), ylabel('Frequency / \Delta f')
        title('Fundamental Frequeny Trajectory');
        
        %         subplot(2,2,4)
        %         plot(s(partCnt).compSine,'.')
        %         grid on
        %         line([0 real(s(partCnt).compSine)],[0 imag(s(partCnt).compSine)])
        %         axis square
        %         xlim([-1,1])
        %         ylim([-1,1])
        %         xlabel('Real')
        %         ylabel('Imag')
        %         title('Instantaneous Phase')
        %         hold off
        
        pause(0.01)
        %         drawnow
        shg
        
    end
    
end


%% PLOT

% if plotit==1
%
%     figure
%     hold on
%     figure
%     plot(out)
%
%
%     nPlots = 4;
%     figure
%     hold on
%
%     for frameCnt=1:nPlots
%
%         y = zeros(nPlots*lHop+lWin,1);
%
%         inds = frameCnt*lHop:frameCnt*lHop+lWin-1;
%
%         y(inds) =     y(inds) + Y(:,frameCnt) ;
%
%         subplot(nPlots,1,frameCnt);
%         plot(y)
%
%         shg,
%     end
%
% end

