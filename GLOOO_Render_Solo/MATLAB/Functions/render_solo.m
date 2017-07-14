%% function [ y ] = render_solo( freqTrack, vibTrack, SM, expMod, paramSynth )
%
%   - generates a solo based on
%
%
% HvC
% Created:  2016-02-18
% Modified: 2016-08-04


function [ y ] = render_solo(~, SOLO, SM, expMod, paths, paramSynth)


% calulate ratio between analysis and synthesis stepsize:

stepAnalys = (SOLO.param.lHop / SOLO.param.fs);
stepSyn    = (paramSynth.lHop / paramSynth.fs);

paramSynth.stepRatioA = stepSyn/stepAnalys;

%% unpack the solo

SEG     = SOLO.SEG;
param   = SOLO.param;


%%

t           = (0:(SEG{end}.stopSEC)*paramSynth.fs-1)/paramSynth.fs;

% a zero padded output stream
y           = [zeros(size(t))'; zeros(paramSynth.fs,1)];


L           = length(y);
lWin        = paramSynth.lWin;
lHop        = paramSynth.lHop;
nWin        = floor((L-2*lWin)/lHop);
targetInds  = 1:lWin;
%nNotes      = size(notes,2);

SP          = [];
SMSP        = [];

% this array keeps track of processed messages
% usedNotes    = zeros(nNotes,1);
% and this one of controllers
% usedCntrls  = zeros(nControls,1);

nSeg    = length(SEG);
segCNT = 1;

%% LOOP over all frames

for frameIDX = 1:nWin
    
    if paramSynth.verbose == true
        disp(['Rendering frame ' num2str(frameIDX) ' of ' num2str(nWin)]);
    end
    
    % times (in sec.) to be filled in this loop run
    targetTimes = (targetInds-1)/paramSynth.fs;
    
    % get segments which begin within this frame
    if segCNT<=nSeg
        newSegment = ...
            intersect(find([SEG{segCNT}.startSEC]>=targetTimes(1)),  ...
            find([SEG{segCNT}.startSEC]<=targetTimes(end)));
        
        
        % if there is one
        if ~isempty(newSegment)
            
            % get next segment
            tmpSeg = SEG{segCNT};
            
            % if it is a transition
            %if strcmp(class(tmpSeg),'trans') == 1
                
                % what kind of transition do we have?
                switch tmpSeg.type
                    
                    % ATTACK AND legato and release do not create
                    % independent transitions.
                    % They just trigger a note with specific properties.
                    case 'attack'
                        
                        if paramSynth.verbose == true
                            disp('Got an attack!')
                        end
                        
                        
                        % in transition is not left blank in this case
                        inTrans = SEG{segCNT};
                        
                        % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        % handing over an emty pre-note assumes
                        smsp = single_sinmod_player(tmpSeg, [], inTrans , SM, expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                        
                    case 'detached'
                        
                        if paramSynth.verbose == true
                            disp('Got a detachee!')
                        end
                        
                        % set the old note released
                        SMSP.isReleased = 1;
                        
                        
                        
                        % in transition is not left blank in this case
                        inTrans = SEG{segCNT};
                        
                        % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        preNote = [];
                        smsp = single_sinmod_player(tmpSeg,  [], inTrans, SM,expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                        
                        
                    case 'legato'
                        
                        if paramSynth.verbose == true
                            disp('Got a legato!')
                        end
                        
                        % set the old note released
                        SMSP.isReleased = 1;
                                                
                        
                        % in transition is not left blank in this case
                        inTrans = SEG{segCNT};
                        
                        % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        preNote = [];
                        smsp = single_sinmod_player(tmpSeg,  [], inTrans, SM,expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                        
                        
                        % a glissando transtions KILLS the recent note at once
                        % and lets the new note create the transition trajectories
                    case 'glissando'
                        
                        % connect with next note at once
                        % kill last note at once
                        if paramSynth.verbose == true
                            disp('Got a glissando!')
                        end
                        
                        % in transition is not left blank in this case
                        inTrans = SEG{segCNT};
                        
                        % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        
                        % find (indexes of) players which are not released or finished
                        % (can only be one in the monophonic case
                        actIND = ~([SMSP.isReleased] | [SMSP.isFinished]);
                        
                        % and finish it
                        SMSP(actIND).isFinished = 1;
                        
                        smsp = single_sinmod_player(tmpSeg, SMSP(actIND), inTrans, SM, expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                        
                        
                    case 'release'
                        
                        if paramSynth.verbose == true
                            disp('Got a release!')
                        end
                        
                        SMSP(end).isReleased = 1;
                        
                end
                
                
                % if it is a note
%             elseif strcmp(class(tmpSeg),'note') == 1
%                 
%                 if paramSynth.verbose == true
%                     disp('Got a note!')
%                 end
%             end
            
            segCNT = segCNT+1;
        end
        
    end
    
    
    %% render all active  notes
    
    for noteIDX = 1:length(SMSP)
        
        % process the expressive controls of the active note
        % (the one NOT released)
        if SMSP(noteIDX).isReleased == 0
            
         
        end
        
        
        if SMSP(noteIDX).isFinished == 0
            
            switch paramSynth.synthMode
                
                case 'IFFT'
                    
                    [SMSP(noteIDX),tmpFrame2] = SMSP(noteIDX).get_frame_IFFT();
                    
                case 'TD'
                    
                    [SMSP(noteIDX),tmpFrame2] = SMSP(noteIDX).get_frame_TD();
                    
%                     plot(abs(fft(tmpFrame2))), xlim([0 200]), drawnow, shg
                    
            end
            
            y(targetInds) = y(targetInds) + tmpFrame2;
            
        end
    end
    
    % kill finished notes
    if~isempty(SMSP)
        
        [~, finished]   = find([SMSP.isFinished]== 1);
        
        %SP(finished) = [];
        SMSP(finished) = [];
        
    end
    
    % increment indices
    targetInds = targetInds + paramSynth.lHop;
    
end

