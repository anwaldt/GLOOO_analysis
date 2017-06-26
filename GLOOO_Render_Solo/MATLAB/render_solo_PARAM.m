%% render_solo_PARAM
%
%
%
%
%
%
% Author:  Henrik von Coler
% Created: 2016-08-16


%% script parameters

paramSynth.plotit   = false;
paramSynth.saveit   = true;
paramSynth.verbose  = true;

paramSynth.smsMode  = 'stochastic';
% paramSynth.smsMode  = 'fixed';

paramSynth.toText   = true;

%%  BASIC synthesis  parameters
 
paramSynth.fs       = 44100;

% take care: this HAS TO MATCH the IFFT kernels window size!!!
paramSynth.lWin     = 2^9;
paramSynth.lHop     = paramSynth.lWin/2;


%% how to synthesize the tonal/deterministic part

paramSynth.nPartials =  30;


 %% how to synthesize the control trajectories 
 
% paramSynth.f0mode = 'plain';        % this mode uses only the DC component
 paramSynth.f0mode = 'original';       % this mode uses the exact AC of the analyzed solo
% paramSynth.f0mode = 'vib_orig';       % this mode uses the DC component + the original vibrato


%% how to synthesisze the noise

paramSynth.noiseMode    = 'off';
% paramSynth.noiseMode    = 'on';
% paramSynth.noiseMode    = 'only';


%% which approach is used (only IFFT implemented, yet)

paramSynth.synthMode = 'IFFT';
paramSynth.synthMode = 'TD';


