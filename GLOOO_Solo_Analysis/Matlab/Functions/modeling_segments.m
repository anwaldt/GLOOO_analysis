%% modelling_segments().m
%
% Function for analyzing a sequence!
%
% Henrik von Coler
%
% Created : 2016-08-08
%
%%

function [SEG, INF, CTL] = modeling_segments(baseName, param, paths)


%% load properties of sequence
% this could be needed, is not yet used.

INF = load_solo_properties(regexprep(baseName,'BuK','DPA') , paths);


%% READ WAV

audioPath = [paths.wavPrepared baseName '.wav'];

try
    [x,fs]      = audioread(audioPath);
catch
    [x,fs]      = wavread(audioPath);
end

% add sample rate to parameters
param.fs    = fs;



%% Controll parameter ANALYSIS

CTL = get_controll_trajectories(x, param, audioPath);

if param.plotit == true
    
    figure
    subplot(2,1,1)
    plot(CTL.f0swipe,'r')
    
    hold off
    legend({'FO (swipe)'});
    title('F0 estimation')
    subplot(2,1,2)
    plot(CTL.pitchStrenght)
    title('Pitch Strength')
    legend({'pitch-strength'});
    
    % amplitude plot
    figure
    plot(x);
    hold on;
    plot((1:length(CTL.rmsVec))*param.lHop, CTL.rmsVec*2,'r')
    legend({'x(t)','RMS x 2'});
    title('RMS ')
    
end


%% just get all individual segment boundaries

segBounds = load([paths.segSV regexprep(baseName,'BuK','DPA') '.txt']);



%% Analyze Segments

%[noteBounds, transBounds, noteTrans]  = analyze_segments(segBounds, param, controlTrajectories);

[SEG]  = prepare_segments(segBounds, INF, param, CTL);




%% CALL the Partial Analysis

partialName = [paths.sinusoids baseName '.mat'];

% only calculate, if not existent
if exist(partialName,'file') == 0
    
    [f0vec, partials, noiseFrames, residual, tonal]  =  ...
        get_partial_trajectories(x, param, CTL.f0swipe);
    
    save(partialName, 'partials');
    
    wavwrite(tonal, param.fs, [paths.tonal baseName '.wav']);
    wavwrite(residual, param.fs, [paths.residual baseName '.wav']);
    
else
    
    load(partialName)
    
end

%%

SEG = get_segment_parameters(SEG, CTL, param, paths);


%% Get the note models

%noteModels      =  get_note_parameters(noteBounds, controlTrajectories, I, param);


%% Get the transition models

%transModels     = get_transition_parameters(transBounds, controlTrajectories, param);


%% TODO: Write MIDI File (usable by matrix2midi)

% tMID = create_MIDI_sequence(noteBounds, noteModels ,param);


%% SAVE STUFF

if param.saveit == true
    
    %writemidi(tMID,[paths.MIDI  baseName '.mid']);
    
    save([paths.features regexprep(baseName,'.wav','.mat')],'CTL')
    
    save([paths.segments regexprep(baseName,'.txt','.mat')],'SEG')
    
end
