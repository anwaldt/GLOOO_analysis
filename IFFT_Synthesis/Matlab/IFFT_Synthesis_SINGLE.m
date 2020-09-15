%%  IFFT_Synthesis_SINGLE.m
%
%   Frequency-domain (IFFT) synthesis
%   of a sound with partial trajectories in
%   'GLOOO_Sample_Preaparation'- style.
%
%   Using the pre-calculated main-lobe kernels,
%   This follows the 'Rodet-Style', using the triangular window
%   in the time domain + the (1/4):(3/4) phase condition!
%
%
%   partialAmp set of soundfiles is written for direct evaluation.
%
%
%   Henrik von Coler
%   2014-09-26 : 2015-03-30
%
%
%
%% Paths

close all
clearvars
restoredefaultpath

addpath Functions/
addpath ../Data/

% libPath = '../F0_Estimation_COPY';
% p       = genpath(libPath);
% addpath(p)

p       = genpath('../../F0_Estimation');
addpath(p);


%% paths

paths.sinmod   = ('../../GLOOO_Sample_Preparation/Sinusoidal_Data/');
paths.residual = ('../../GLOOO_Sample_Preparation/Residual/');
paths.original = ('../../GLOOO_Sample_Preparation/Samples/');


%% BASIC PARAMETERS

% this starts the animated plot, if set to '1':
animate = 0;

% and the normal plots:
plotit  = 0;

% Calculate the actual F0 trajectory?
% SLOW !
checkF0 = 1;


%% load analysis data (arbitrary file)
%
% inFile = 'tuned_f_A#2';
%
% the parameters
% load ../../GLOOO_Sample_Preparation/Matlab/parameters
%
% read the original soundfile
% [original, fsO] = audioread(['../../GLOOO_Sample_Preparation/Test_Audio/original.wav']);
% read the noise soundfile
% [residual, fsN] = audioread(['../../GLOOO_Sample_Preparation/Test_Audio/noise.wav']);
% load sinusoidal data
% load(['../../GLOOO_Sample_Preparation/Test_Data/sinMod']);
 
%% load analysis data (glooo- file)

inFile = 'tuned_f_A#2';

load([paths.sinmod inFile]);

[residual, ~] = audioread([paths.residual inFile '.wav']);
 
[original, ~] = audioread([paths.original inFile '.wav']);


%% pre-process sinusoidal data

nPart   = param.nPartials;

% smooth them (just for fun):
for i=1:nPart
    %    partialAmp(i,:) = smooth(partialAmp(i,:),10);
end

 
%%  synthsis parameters (as read from analysis results)

% number of frames to synthesize
nFrames = length(partialAmp);

% sampling frequency
fs      = param.fs;

% synthesis hop size
lHop    = param.lHop;

% synthesis frame length
lWin    = param.lWin;

% hop size in seconds
hop_s   = lHop/fs;

% time axis within one frame
t       = (0:lWin-1)/fs;

% delta frequency (bin distance)
df      =  fs/lWin;


%% Windows

close all


% the frequency domain window:
win1 =  calculate_BH92_complete(lWin) ;

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

% shorten f0
% f0 = f0(1:nFrames);
f0 = partialFre(1,:);

% Vibrato
vibDepth    = 0.01;
fVib        = 40;


F0          = f0;% + sin(2*pi*fVib*(1:nFrames))';

% linear chirp
% F0          = linspace(200,1000,nFrames);
 

% allocate momory for the measured F0 trajectory
F0meas = zeros(size(F0));


%% Load kernel data

load kernel_data
load kernel_data_LF

%% Framewise synthesis

if animate==1
    figure('units','normalized','outerposition',[0 0 1 1])
end

% tonal = zeros(nFrames*lHop+lWin,1);
 tonal  = zeros(size(residual));

 s      = struct(nPart,1);
 
for frameCnt=1:nFrames-1
    
    FRAME = zeros(lWin,1);
    
    % loop over all partials
    for partCnt = 1:nPart
        
        % partial frequency (is always exactly N*f0)
        %         s(partCnt).f0  = partialFre(frameCnt) * partCnt;
        
        % or read it from the table, directly
        s(partCnt).f0 = partialFre(partCnt, frameCnt);
        
        %
        s(partCnt).a  = partialAmp(partCnt,frameCnt);
        
        % start with zero-phase (OR RANDOM)
        if frameCnt==1
            s(partCnt).thisPhas = rand*pi;
            s(partCnt).lastPhas = rand*pi;
            s(partCnt).compSine = 1;
            % 'floating point position' of this partial
            s(partCnt).fracBin  = 1;
        end
        
        % add this partial to the spectrum
        if s(partCnt).f0 > 50
            [tmpFrame, s(partCnt)] = place_mainlobe( s(partCnt),lWin,fs,kernels,kernels_LF,fracVec, fracVec_LF);
            FRAME    = FRAME+tmpFrame;
        end
    end
    
    % SCALE - @TODO: the scaling factor has been chosen heuristically!!!
%     FRAME = FRAME * 10;
    
    % transform
    tmpFrame  = ifft(FRAME, 'symmetric');
    
    % get rid of the BH-window in time-domain and apply triangular window
    tmpFrame  = tmpFrame.*win2;
    
    % OLA' it
    inds      = ((frameCnt-1)*lHop +1) : ((frameCnt-1)*lHop+lWin);

    try
        tonal(inds) = tonal(inds) + tmpFrame;
    catch
        'XXX';
    end
    
    if checkF0==1
        F0meas(frameCnt) = get_f0_autocorr(tmpFrame,fs,10,10,4000);
    end
    
    % FRAMEWISE ANIMATION ?
    if animate==1
        
        framewise_animation();
        
    end
    
end

complete = tonal+residual;

%% Write Audio Files


audiowrite('../Audio/tonal.wav'      ,tonal      ,fs);
audiowrite('../Audio/residual.wav'   ,residual   ,fs);
audiowrite('../Audio/complete.wav'   ,complete   ,fs);
audiowrite('../Audio/original.wav'   ,original   ,fs);

%% PLOT

% this plot shows remaining partials in the magnitude spectrum
% plot(linspace(0,fs,length(fft(residual))),    abs((fft(residual)))),xlim([0 20000])

% if plotit==1
%
%     figure
%     hold on
%     figure
%     plot(tonal)
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

