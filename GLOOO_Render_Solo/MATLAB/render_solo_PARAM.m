

paramSynth.plotit = true;
paramSynth.saveit = true;

%%   synthesis  parameters


% load SAMPLE analysis parameters
load([paths.PARAM 'parameters_18-Aug-2016_.mat']);

paramSynth.nPartials    = param.PART.nPartials;

 paramSynth.noiseMode    = 'off';
% paramSynth.noiseMode    = 'on';
% paramSynth.noiseMode    = 'only';


paramSynth.fs       = 44100;


paramSynth.lWin     = param.PART.lWin/2;
paramSynth.lHop     = param.lHop;

% paramSynth.f0mode = 'plain';        % this mode uses only the DC component
 paramSynth.f0mode = 'original';       % this mode uses the exact AC of the analyzed solo
% paramSynth.f0mode = 'vib_orig';       % this mode uses the DC component + the original vibrato

paramSynth.synthMode = 'IFFT';