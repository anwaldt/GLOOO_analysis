%% modelling_segments().m
%
% Function for analyzing a sequence!
%
% Henrik von Coler
%
% Created : 2016-08-08
%
%%

function [S] = modeling_segments(baseName, param, paths)


%% load properties of sequence
% this could be needed, is not yet used.

I = load_solo_properties(regexprep(baseName,'BuK','DPA') , paths);


%% READ WAV

audioPath = [paths.wavPrepared baseName '.wav'];

try
    [x,fs]      = audioread(audioPath);
catch
    [x,fs]      = wavread(audioPath);
end

% add sample rate to parameters
param.fs    = fs;


%% just get all individual segment boundaries

segBounds = load([paths.segSV regexprep(baseName,'BuK','DPA') '.txt']);


%% Controll parameter ANALYSIS

controlTrajectories = get_controll_trajectories(x, param, audioPath);

if param.plotit == true
    
    figure
    subplot(2,1,1)
    plot(controlTrajectories.f0swipe,'r')
    
    hold off
    legend({'FO (swipe)'});
    title('F0 estimation')
    subplot(2,1,2)
    plot(controlTrajectories.pitchStrenght)
    title('Pitch Strength')
    legend({'pitch-strength'});
    
    % amplitude plot
    figure
    plot(x);
    hold on;
    plot((1:length(controlTrajectories.rmsVec))*param.lHop, controlTrajectories.rmsVec*2,'r')
    legend({'x(t)','RMS x 2'});
    title('RMS ')
    
end




%% Analyze Segments

%[noteBounds, transBounds, noteTrans]  = analyze_segments(segBounds, param, controlTrajectories);

[S]  = prepare_segments(segBounds, I, param, controlTrajectories);




%% CALL the Partial Analysis

partialName = [paths.sinusoids baseName '.mat'];

% only calculate, if not existent
if exist(partialName,'file') == 0
    
    [f0vec, partials, noiseFrames, residual, tonal]  =  ...
        get_partial_trajectories(x, param, controlTrajectories.f0swipe);
    
    save(partialName, 'partials');
    
    wavwrite(tonal, param.fs, [paths.tonal baseName '.wav']);
    wavwrite(residual, param.fs, [paths.residual baseName '.wav']);
    
else
    
    load(partialName)
    
end

%%

SEG = get_segment_parameters(S, controlTrajectories, param);


%% Get the note models

%noteModels      =  get_note_parameters(noteBounds, controlTrajectories, I, param);


%% Get the transition models

%transModels     = get_transition_parameters(transBounds, controlTrajectories, param);




%% TODO: Write MIDI File (usable by matrix2midi)

% tMID = create_MIDI_sequence(noteBounds, noteModels ,param);


%% SAVE STUFF

if param.saveit == true
    
    %writemidi(tMID,[paths.MIDI  baseName '.mid']);
    
    save([paths.features regexprep(baseName,'.wav','.mat')],'controlTrajectories')
    
    save([paths.segments regexprep(baseName,'.txt','.mat')],'SEG')
    
%     save([paths.notes  (baseName)],'noteModels');
%     
%     save([paths.transitions  (baseName)],'transModels')
    
end