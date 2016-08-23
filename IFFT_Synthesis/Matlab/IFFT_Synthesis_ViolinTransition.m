%% IFFT_Synthesis_ViolinTransition.m
%
%   Frequency-domain (IFFT) synthesis
%   of two violin sounds, connected by synthetic glissando
%   with partial trajectories in
%   'GLOOO_Sample_Preaparation'
%   using the pre-calculated main-lobe kernels
%   and a very simple partial interpolation
%
%   This follows the 'Rodet-Style', using the triangular window
%   in the time domain + the (1/4):(3/4) phase condition!
%
%
%   Henrik von Coler
%   2014-09- 29


%% Paths

close all
clearvars
% restoredefaultpath

addpath Functions/
addpath Data/

libPath = '/media/henrikvoncoler/HVC/F0_Estimation_COPY';
p       = genpath(libPath);
addpath(p)

p       = genpath('/media/henrikvoncoler/HVC/F0_Estimation/');
addpath(p);


%% Transition Definition

% number of frames from note 1 to synthesize
nNote1 = 150;

% length of note 2 (in frames):
nNote2 = 200;

% starting point of note 2:
sNote2 = 20;

% length of the transition
lTrans = 30;


%% BASIC PARAMETERS

% this starts the animated plot, if set to '1':
animate = 0;
% and the normal plots:
plotit  = 1;

% calculate the actual F0 trajectory?
% SLOW !
checkF0 = 1;

% sampling frequency
fs    = 44100;

% synthesis frame length
lWin  = 2^10;

% synthesis hop size
lHop   = lWin/2;

% hop size in seconds
hop_s  = lHop/fs;

% time axis within one frame
t   = (0:lWin-1)/fs;

% delta frequency (bin distance)
df  =  fs/lWin;

%% Windows

close all

% the frequency domain window:
win1 =  calculate_BH92_complete(lWin) ;
% This is not needed anymore - it is in the kernels:
% WIN1 =  real(fftshift(    fft(win1) ));

% the time-domain window
win2 = (triang(lWin))./win1;



%% F0-Control Parameters

% basic vibrato parameters
fVib     = 30;
aVib     = 0.003;

% f0-trajectory – note 1
vibTraj1 = aVib * sin(linspace(0,pi,nNote1));
F0_1      = 440*(ones( 1,nNote1) + vibTraj1 .* sin((1:nNote1)/(fs/lHop)*fVib));

% f0-trajectory – note 2
vibTraj2 = aVib * sin(linspace(0,pi,nNote2));
F0_2      = 440*2^(-3/12)*(ones( 1,nNote2) + vibTraj2 .* sin((1:nNote2)/(fs/lHop)*fVib));

% f0-trajectory – transition
F0_trans = F0_1(end) -   abs(F0_1(end)-F0_2(1)) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));

% concatenate
F0_comp    = [F0_1, F0_trans, F0_2];

% linear chirp
%  F0     = linspace(200,1000,nFrames);

% F expressed in terms of the delta_f
%F0     = linspace(6.1*(fs/lWin),36.4*(fs/lWin),nFrames);

figure
plot(linspace(-5,5,lTrans),F0_trans)

%% load analysis data

% the parameters
load /media/henrikvoncoler/HVC/GLOOO_Sample_Preparation/Matlab/parameters
nPart = p.nPartials;

% load violin tone amplitude trajectories
A1 = dlmread('/media/henrikvoncoler/HVC/GLOOO_Sample_Preparation/Sinusoidal_Data/tuned_f_A3.snmd')';
A2 = dlmread('/media/henrikvoncoler/HVC/GLOOO_Sample_Preparation/Sinusoidal_Data/tuned_f_C3.snmd')';

l1 = length(A1(1,:));
l2 = length(A2(1,:));

% apply amplitude vibrato to the partials
for i=1:nPart
    
    tmpA1    = 0.2;
    tmpTraj1 = tmpA1 * sin(linspace(0,pi,l1)+rand*pi);
    A1(i,:)  = A1(i,:) .* (ones( 1,l1) + tmpTraj1 .* sin((1:l1)/(fs/lHop)*fVib));
    
    tmpA2    = 0.2;
    tmpTraj2 = tmpA2 * sin(linspace(0,pi,l2)+rand*pi);
    A2(i,:)  = A2(i,:) .* (ones( 1,l2) + tmpTraj2 .* sin((1:l2)/(fs/lHop)*fVib));
end

% create a sigmoidal glissando
Atrans = zeros(nPart,lTrans);
for i=1:nPart
    
    if A1(i,nNote1) <=A2(i,sNote2)
        Atrans(i,:) = A1(i,nNote1) +   abs(A1(i,nNote1)-A2(i,sNote2)) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));
    else
        Atrans(i,:) = A1(i,nNote1) -   abs(A1(i,nNote1)-A2(i,sNote2)) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));
    end
    
    % additional damping of higher partials during the transition:
    Atrans(i,:) =   Atrans(i,:).* (1- (4*i/nPart)* sin(linspace(0,pi,lTrans)));

end

Acomp = [A1(:,1:nNote1), Atrans, A2(:,sNote2:sNote2+nNote2)];

% smooth them (just for fun):
for i=1:nPart
    %     Acomp(i,:) = smooth(Acomp(i,:),1);
end

figure
plot(Acomp')

%% Load kernel data

load kernel_data
load kernel_data_LF

%% Framewise synthesis

% initialize a set of partials
for i=1:nPart
    
    s(i).thisPhas = rand*pi;
    s(i).lastPhas = rand*pi;
    s(i).compSine = 1;
    
    % 'floating point position' of this partial
    s(i).fracBin  = 1;

end

% synthesis loop
inds = 1:lWin;
out  = zeros(length(Acomp)*lHop+lWin,1);
for frameCnt=1:length(Acomp)-1
    
    
    f0           = F0_comp(frameCnt)*(1+rand/1000);
    Aframe       = Acomp(:,frameCnt);
    [tmpFrame,s] = assemble_spectral_frame(s,f0,Aframe, win2, lWin,fs,kernels,kernels_LF,fracVec,fracVec_LF);
    
    % OLA' it
    out(inds) = out(inds) + tmpFrame ;
    % and increase indices
    inds      = inds+lHop;
    
end

