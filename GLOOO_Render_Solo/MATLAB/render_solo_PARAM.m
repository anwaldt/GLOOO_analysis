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

% use the original ampliutude and frequency trajectories
% or the prepared distribution functions:
paramSynth.smsMode  = 'stochastic';
% paramSynth.smsMode  = 'fixed';


paramSynth.toText   = true;

%%  BASIC synthesis  parameters

paramSynth.fs       = 44100;

% take care: this HAS TO MATCH the IFFT kernels window size
%            in case of IFFT synthesis (obsolete, now)
paramSynth.lWin     = 2^9;
paramSynth.lHop     = paramSynth.lWin/2;


%% which approach is used (only IFFT implemented, yet)

paramSynth.synthMode = 'IFFT';
paramSynth.synthMode = 'TD';


%% how to synthesize the tonal/deterministic part

% number of partials to synthesize
paramSynth.nPartials =  30;

paramSynth.partialsTODO = 1:paramSynth.nPartials;
% paramSynth.partialsTODO = [1 10 20 30];


%% how to synthesize the control trajectories during sustain
% both AMPLITUDE and FREQUENCY

% this mode uses only the DC component
% paramSynth.sustainMode = 'plain';

% this mode uses the exact AC of the analyzed solo:
paramSynth.sustainMode = 'original';

% this mode uses the DC component + the original vibrato:
% paramSynth.f0mode = 'vib_orig';

%% how to synthesize the glissandi

paramSynth.glissandoMode    = 'original-partials';

%paramSynth.glissandoMode    = 'linear';

%% how to synthesize the glissandi

paramSynth.vibratoMode    = 'linear';


%% how to synthesize the attacks

paramSynth.attackMode       = 'original';

%% how to synthesisze the noise

paramSynth.noiseMode        = 'off';
% paramSynth.noiseMode      = 'on';
% paramSynth.noiseMode      = 'only';

