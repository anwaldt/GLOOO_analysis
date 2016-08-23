


%% choose basic settings

param.parallel      = false;
param.plotit        = false;
param.saveit        = false;

param.writeWav      = true;
param.writeMat      = true;
param.writeTxt      = true;


%% PARTIAL parameters

% due to parfor variable restrictions, we need to set this manually
param.fs            = 96000;


%% BASIC PARAMTERS



%% GLOABAL analyis parameters

% the hop-size is GLOBAL:
param.lHop          = 2^10;

param.lWinRMS       = 2^11;
param.lWinNoise     = 2^12;
param.lWinSynth     = 2^12;


%% F0 ANALYSIS

param.F0.f0Mode         = 'swipe';
param.F0.lWinYIN        = 2^13;
param.F0.lWinF0         = 2^13;

param.F0.minStrength    = 0.25;

%% f0 decomposition

param.F0decomp.tresh1       = 0.1;
param.F0decomp.cutHighHZ    = 1;
param.F0decomp.cutLowHZ     = 10;


%% Partial tracking

% print the frame information?
param.PART.info         = false;

% CAREFUL: this also decides, whether the residual is calculated
% - so just set 'false' if only the partial amplitudes and frequencies are  needed!
param.PART.getPhases    = true;
param.PART.lWin         = 2^12;

% upsampling for the autocorr f0-detection
param.PART.upsampFactor  = 5;

% windowsize of peak picking
param.PART.nFFT          = 2^13;
param.PART.nPartials     = 30;
param.PART.fMin          = 20;
param.PART.fMax          = 4000;

% this is for the precision of the phase estimation
% keep in mind: it takes 'param.nPhaseSteps' coarse
%               and 'param.nPhaseSteps' fine steps
param.PART.nPhaseSteps   = 10  ;

